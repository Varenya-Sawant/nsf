#!/usr/bin/env bash
# =============================================================================
# test_nsf.sh — Test suite for nsf
#
# Run with:  bash tests/test_nsf.sh
# Or via CI: automatically triggered on every push and PR
#
# Each test function is named test_*. The runner at the bottom collects and
# executes them all, tracking pass/fail counts and printing a summary.
# Tests are isolated — each one creates a temporary directory and cleans up.
# =============================================================================

set -u

# -----------------------------------------------------------------------------
# Test framework — minimal, no external dependencies
# -----------------------------------------------------------------------------

PASS=0
FAIL=0
ERRORS=()

# Prints a pass line and increments the counter
pass() {
    local name="$1"
    echo "  ✓ ${name}"
    PASS=$(( PASS + 1 ))
}

# Prints a fail line, records the error, increments the counter
fail() {
    local name="$1"
    local reason="${2:-}"
    echo "  ✗ ${name}${reason:+ — ${reason}}"
    ERRORS+=("${name}${reason:+: ${reason}}")
    FAIL=$(( FAIL + 1 ))
}

# assert_exit_ok: runs a command and asserts it exits 0
assert_exit_ok() {
    local name="$1"; shift
    if "$@" > /dev/null 2>&1; then
        pass "${name}"
    else
        fail "${name}" "expected exit 0, got $?"
    fi
}

# assert_exit_fail: runs a command and asserts it exits non-zero
assert_exit_fail() {
    local name="$1"; shift
    if ! "$@" > /dev/null 2>&1; then
        pass "${name}"
    else
        fail "${name}" "expected non-zero exit, got 0"
    fi
}

# assert_file_exists: checks a file was created
assert_file_exists() {
    local name="$1"
    local filepath="$2"
    if [[ -f "${filepath}" ]]; then
        pass "${name}"
    else
        fail "${name}" "file not found: ${filepath}"
    fi
}

# assert_file_contains: checks file content includes a string
assert_file_contains() {
    local name="$1"
    local filepath="$2"
    local needle="$3"
    if grep -q "${needle}" "${filepath}" 2>/dev/null; then
        pass "${name}"
    else
        fail "${name}" "'${needle}' not found in ${filepath}"
    fi
}

# assert_file_not_exists: checks a file was NOT created
assert_file_not_exists() {
    local name="$1"
    local filepath="$2"
    if [[ ! -f "${filepath}" ]]; then
        pass "${name}"
    else
        fail "${name}" "file should not exist: ${filepath}"
    fi
}

# assert_output_contains: checks command stdout includes a string
assert_output_contains() {
    local name="$1"
    local needle="$2"; shift 2
    local output
    output=$("$@" 2>&1 || true)
    if echo "${output}" | grep -q "${needle}"; then
        pass "${name}"
    else
        fail "${name}" "output did not contain '${needle}'"
    fi
}

# assert_executable: checks file has execute permission
assert_executable() {
    local name="$1"
    local filepath="$2"
    if [[ -x "${filepath}" ]]; then
        pass "${name}"
    else
        fail "${name}" "file is not executable: ${filepath}"
    fi
}

# -----------------------------------------------------------------------------
# Setup — resolve nsf binary path relative to this test file
# -----------------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NSF_BIN="${SCRIPT_DIR}/../bin/nsf"

# Ensure the binary is executable
chmod +x "${NSF_BIN}"

# Disable interactive prompts during tests
export ENABLE_EDITOR_SELECTION="false"
export ENABLE_GIT_INTEGRATION="false"
export NSF_AUTHOR="Test Author"
export NSF_DEBUG="false"

# Helper: create a temp dir, cd into it, and register cleanup
setup_tmpdir() {
    # Creates a temp dir and prints its path.
    # The CALLER is responsible for cd-ing into it.
    # (cd inside $() runs in a subshell and does not affect the parent shell)
    mktemp -d
}

cleanup_tmpdir() {
    local tmpdir="$1"
    cd /tmp
    rm -rf "${tmpdir}"
}

# =============================================================================
# Test groups
# =============================================================================

# -----------------------------------------------------------------------------
test_informational_flags() {
    echo ""
    echo "Informational flags"

    assert_exit_ok     "--help exits 0"        "${NSF_BIN}" --help
    assert_exit_ok     "--version exits 0"     "${NSF_BIN}" --version
    assert_exit_ok     "--list exits 0"        "${NSF_BIN}" --list
    assert_exit_ok     "-h exits 0"            "${NSF_BIN}" -h
    assert_exit_ok     "-v exits 0"            "${NSF_BIN}" -v
    assert_exit_ok     "-l exits 0"            "${NSF_BIN}" -l

    assert_output_contains "--version shows version number" "3.2.0" \
        "${NSF_BIN}" --version

    assert_output_contains "--list shows python" "py" \
        "${NSF_BIN}" --list

    assert_output_contains "--help shows --dry-run" "dry-run" \
        "${NSF_BIN}" --help
}

# -----------------------------------------------------------------------------
test_file_creation_all_languages() {
    echo ""
    echo "File creation — all 11 languages"

    local tmpdir
    tmpdir=$(setup_tmpdir)
    cd "${tmpdir}"

    local -A test_cases=(
        [script.sh]="#!/usr/bin/env bash"
        [script.bash]="#!/usr/bin/env bash"
        [script.py]="#!/usr/bin/env python3"
        [script.js]="use strict"
        [script.ts]="async function main"
        [main.go]="package main"
        [main.rs]="fn main"
        [script.rb]="#!/usr/bin/env ruby"
        [script.php]="declare(strict_types"
        [main.c]="#include <stdio.h>"
        [main.cpp]="#include <iostream>"
        [Main.java]="public class"
    )

    local file pattern
    for file in "${!test_cases[@]}"; do
        pattern="${test_cases[${file}]}"
        "${NSF_BIN}" "${file}" > /dev/null 2>&1 || true
        assert_file_exists     "creates ${file}"      "${file}"
        assert_file_contains   "${file} has content"  "${file}" "${pattern}"
    done

    cleanup_tmpdir "${tmpdir}"
}

# -----------------------------------------------------------------------------
test_variable_substitution() {
    echo ""
    echo "Variable substitution"

    local tmpdir
    tmpdir=$(setup_tmpdir)
    cd "${tmpdir}"

    NSF_AUTHOR="Jane Tester" "${NSF_BIN}" mymodule.py > /dev/null 2>&1
    assert_file_contains "author token replaced"      mymodule.py "Jane Tester"
    assert_file_contains "filename token replaced"    mymodule.py "mymodule.py"
    assert_file_contains "basename token replaced"    mymodule.py "mymodule"

    "${NSF_BIN}" --desc "Data pipeline script" pipeline.sh > /dev/null 2>&1
    assert_file_contains "--desc injected into file"  pipeline.sh "Data pipeline script"

    # Java uses PascalCase basename
    "${NSF_BIN}" my_service.java > /dev/null 2>&1
    assert_file_contains "java PascalCase class name" my_service.java "MyService"

    cleanup_tmpdir "${tmpdir}"
}

# -----------------------------------------------------------------------------
test_overwrite_protection() {
    echo ""
    echo "Overwrite protection"

    local tmpdir
    tmpdir=$(setup_tmpdir)
    cd "${tmpdir}"

    # Create a file with known content
    echo "original content" > existing.sh

    # Default: should refuse to overwrite
    assert_exit_fail "default refuses overwrite" \
        "${NSF_BIN}" existing.sh

    assert_file_contains "original content preserved" \
        existing.sh "original content"

    cleanup_tmpdir "${tmpdir}"
}

# -----------------------------------------------------------------------------
test_backup_flag() {
    echo ""
    echo "--backup flag"

    local tmpdir
    tmpdir=$(setup_tmpdir)
    cd "${tmpdir}"

    echo "original" > myscript.sh
    "${NSF_BIN}" --backup myscript.sh > /dev/null 2>&1

    assert_file_exists    "backup file created"    "myscript.sh.bak"
    assert_file_contains  "backup has original"    "myscript.sh.bak" "original"
    assert_file_contains  "new file has template"  "myscript.sh"     "#!/usr/bin/env bash"

    cleanup_tmpdir "${tmpdir}"
}

# -----------------------------------------------------------------------------
test_dry_run() {
    echo ""
    echo "--dry-run flag"

    local tmpdir
    tmpdir=$(setup_tmpdir)
    cd "${tmpdir}"

    "${NSF_BIN}" --dry-run analysis.py > /dev/null 2>&1
    assert_file_not_exists "dry-run creates nothing" "analysis.py"

    assert_output_contains "dry-run shows resolved content" "#!/usr/bin/env python3" \
        "${NSF_BIN}" --dry-run analysis.py

    assert_output_contains "dry-run shows filename" "analysis.py" \
        "${NSF_BIN}" --dry-run analysis.py

    cleanup_tmpdir "${tmpdir}"
}

# -----------------------------------------------------------------------------
test_batch_creation() {
    echo ""
    echo "Batch creation"

    local tmpdir
    tmpdir=$(setup_tmpdir)
    cd "${tmpdir}"

    "${NSF_BIN}" handler.go middleware.go router.go > /dev/null 2>&1
    assert_file_exists "batch creates file 1" "handler.go"
    assert_file_exists "batch creates file 2" "middleware.go"
    assert_file_exists "batch creates file 3" "router.go"

    # Batch with one existing file — others should still be created
    echo "existing" > exists.py
    "${NSF_BIN}" exists.py newfile.py > /dev/null 2>&1 || true
    assert_file_contains "existing skipped in batch"  "exists.py"  "existing"
    assert_file_exists   "new file created in batch"  "newfile.py"

    cleanup_tmpdir "${tmpdir}"
}

# -----------------------------------------------------------------------------
test_preview() {
    echo ""
    echo "--preview flag"

    assert_exit_ok "preview sh exits 0"   "${NSF_BIN}" --preview sh
    assert_exit_ok "preview py exits 0"   "${NSF_BIN}" --preview py
    assert_exit_ok "preview go exits 0"   "${NSF_BIN}" --preview go
    assert_exit_ok "preview c exits 0"    "${NSF_BIN}" --preview c
    assert_exit_ok "preview java exits 0" "${NSF_BIN}" --preview java

    assert_output_contains "preview shows raw token" "{{NSF_AUTHOR}}" \
        "${NSF_BIN}" --preview py

    assert_exit_fail "preview unknown ext fails" \
        "${NSF_BIN}" --preview xyz
}

# -----------------------------------------------------------------------------
test_error_cases() {
    echo ""
    echo "Error handling"

    assert_exit_fail "no filenames exits non-zero"       "${NSF_BIN}" --dry-run
    assert_exit_fail "unknown flag exits non-zero"      "${NSF_BIN}" --not-a-real-flag
    assert_exit_fail "unsupported extension fails"      "${NSF_BIN}" file.xyz 2>/dev/null || true
    assert_exit_fail "no extension fails"               "${NSF_BIN}" justfilename 2>/dev/null || true

    # Path traversal attempt should be rejected
    local tmpdir
    tmpdir=$(setup_tmpdir)
    cd "${tmpdir}"
    assert_exit_fail "path traversal rejected" \
        "${NSF_BIN}" "path/to/file.sh"
    cleanup_tmpdir "${tmpdir}"
}

# -----------------------------------------------------------------------------
test_executable_bit() {
    echo ""
    echo "Executable bit"

    local tmpdir
    tmpdir=$(setup_tmpdir)
    cd "${tmpdir}"

    export DEFAULT_MAKE_EXECUTABLE="true"

    "${NSF_BIN}" myscript.sh > /dev/null 2>&1
    assert_executable "sh file is executable" "myscript.sh"

    "${NSF_BIN}" myscript.py > /dev/null 2>&1
    assert_executable "py file is executable" "myscript.py"

    "${NSF_BIN}" main.go > /dev/null 2>&1
    # Go source files should NOT be made executable
    if [[ ! -x "main.go" ]]; then
        pass "go file is NOT executable"
    else
        fail "go file is NOT executable" "go source should not be chmod +x"
    fi

    cleanup_tmpdir "${tmpdir}"
}

# -----------------------------------------------------------------------------
test_user_template_override() {
    echo ""
    echo "User template override"

    local tmpdir
    tmpdir=$(setup_tmpdir)
    cd "${tmpdir}"

    # Create a fake user template directory with a custom python template
    local user_tmpl_dir="${tmpdir}/user_templates"
    mkdir -p "${user_tmpl_dir}"
    echo "# CUSTOM TEMPLATE by {{NSF_AUTHOR}}" > "${user_tmpl_dir}/py.tmpl"

    # Point nsf to the custom user template dir
    NSF_USER_TEMPLATE_DIR="${user_tmpl_dir}" \
        "${NSF_BIN}" mytest.py > /dev/null 2>&1

    assert_file_contains "user template used over system" \
        "mytest.py" "CUSTOM TEMPLATE"

    cleanup_tmpdir "${tmpdir}"
}

# =============================================================================
# Runner — collects all test_* functions and executes them
# =============================================================================

echo "═══════════════════════════════════════════════════"
echo "  nsf test suite"
echo "═══════════════════════════════════════════════════"

test_informational_flags
test_file_creation_all_languages
test_variable_substitution
test_overwrite_protection
test_backup_flag
test_dry_run
test_batch_creation
test_preview
test_error_cases
test_executable_bit
test_user_template_override

# -----------------------------------------------------------------------------
# Summary
# -----------------------------------------------------------------------------
echo ""
echo "═══════════════════════════════════════════════════"
total=$(( PASS + FAIL ))
echo "  Results: ${PASS}/${total} passed"

if [[ ${FAIL} -gt 0 ]]; then
    echo ""
    echo "  Failed tests:"
    for err in "${ERRORS[@]}"; do
        echo "    ✗ ${err}"
    done
    echo "═══════════════════════════════════════════════════"
    exit 1
else
    echo "  All tests passed."
    echo "═══════════════════════════════════════════════════"
    exit 0
fi
