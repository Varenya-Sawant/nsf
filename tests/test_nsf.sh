#!/usr/bin/env bash

# NSF Test Suite
# Run comprehensive tests for NSF functionality

set -euo pipefail

# Source NSF libraries
NSF_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${NSF_DIR}/lib/constants.sh"
source "${NSF_DIR}/lib/logger.sh"
source "${NSF_DIR}/lib/utils.sh"
source "${NSF_DIR}/lib/templates.sh"
source "${NSF_DIR}/lib/core.sh"

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Temporary test directory
TEST_DIR="/tmp/nsf_test_$$"
mkdir -p "$TEST_DIR"

# Cleanup on exit
cleanup() {
    rm -rf "$TEST_DIR"
}
trap cleanup EXIT

# Test helper functions
test_case() {
    local test_name="$1"
    echo ""
    show_section "TEST: $test_name"
    ((TESTS_RUN++))
}

pass() {
    echo "✓ PASSED"
    ((TESTS_PASSED++))
}

fail() {
    local reason="${1:-Unknown reason}"
    echo "✗ FAILED: $reason"
    ((TESTS_FAILED++))
}

# Initialize
show_header "NSF Test Suite"

# ============================================
# Test 1: Constants Loading
# ============================================
test_case "Constants are loaded"
if [[ -n "${NSF_VERSION}" ]] && [[ "${NSF_VERSION}" == "3.1.0" ]]; then
    pass
else
    fail "NSF_VERSION not set correctly"
fi

# ============================================
# Test 2: Supported Extensions
# ============================================
test_case "Supported extensions available"
if [[ ${#SUPPORTED_EXTENSIONS[@]} -eq 9 ]]; then
    pass
else
    fail "Expected 9 languages, found ${#SUPPORTED_EXTENSIONS[@]}"
fi

# ============================================
# Test 3: Logger initialization
# ============================================
test_case "Logger initializes without error"
if init_logger; then
    pass
else
    fail "Logger initialization failed"
fi

# ============================================
# Test 4: File extension extraction
# ============================================
test_case "Extract extension from filename"
ext=$(get_extension "script.py")
if [[ "$ext" == "py" ]]; then
    pass
else
    fail "Expected 'py', got '$ext'"
fi

# ============================================
# Test 5: Validate supported extension
# ============================================
test_case "Validate supported language (Python)"
if validate_extension "py"; then
    pass
else
    fail "Python extension validation failed"
fi

# ============================================
# Test 6: Reject unsupported extension
# ============================================
test_case "Reject unsupported language"
if ! validate_extension "xyz" 2>/dev/null; then
    pass
else
    fail "Unsupported language should be rejected"
fi

# ============================================
# Test 7: All supported extensions
# ============================================
test_case "All 9 languages are supported"
langs=" sh bash py js ts go rs rb php "
failures=0
for lang in sh bash py js ts go rs rb php; do
    if ! validate_extension "$lang" 2>/dev/null; then
        ((failures++))
        echo "Missing: $lang"
    fi
done
if [[ $failures -eq 0 ]]; then
    pass
else
    fail "$failures languages unsupported"
fi

# ============================================
# Test 8: Get supported extensions list
# ============================================
test_case "Get list of supported extensions"
exts=$(get_supported_extensions)
if [[ ${#exts} -gt 10 ]]; then
    pass
else
    fail "Extension list too short: $exts"
fi

# ============================================
# Test 9: Bash template generation
# ============================================
test_case "Generate Bash template"
template=$(get_template "sh")
if [[ $template == *"#!/usr/bin/env bash"* ]]; then
    pass
else
    fail "Bash template missing proper shebang"
fi

# ============================================
# Test 10: Python template generation
# ============================================
test_case "Generate Python template"
template=$(get_template "py")
if [[ $template == *"#!/usr/bin/env python3"* ]]; then
    pass
else
    fail "Python template missing proper shebang"
fi

# ============================================
# Test 11: JavaScript template generation
# ============================================
test_case "Generate JavaScript template"
template=$(get_template "js")
if [[ $template == *"#!/usr/bin/env node"* ]] || [[ $template == *"'use strict'"* ]]; then
    pass
else
    fail "JavaScript template missing proper structure"
fi

# ============================================
# Test 12: Go template generation
# ============================================
test_case "Generate Go template"
template=$(get_template "go")
if [[ $template == *"package main"* ]]; then
    pass
else
    fail "Go template missing package declaration"
fi

# ============================================
# Test 13: Rust template generation
# ============================================
test_case "Generate Rust template"
template=$(get_template "rs")
if [[ $template == *"fn main()"* ]]; then
    pass
else
    fail "Rust template missing main function"
fi

# ============================================
# Test 14: Configuration file paths
# ============================================
test_case "Config directory path valid"
if [[ -n "${NSF_CONFIG_DIR}" ]]; then
    pass
else
    fail "Config directory not set"
fi

# ============================================
# Test 15: Create test script file
# ============================================
test_case "Create Bash script file"
test_script="${TEST_DIR}/test_script.sh"
cp <(get_template "sh") "$test_script"
if [[ -f "$test_script" ]]; then
    pass
else
    fail "Failed to create test script"
fi

# ============================================
# Test 16: Make file executable
# ============================================
test_case "Make file executable"
make_executable "$test_script"
if [[ -x "$test_script" ]]; then
    pass
else
    fail "Failed to make file executable"
fi

# ============================================
# Test 17: Ensure directory creation
# ============================================
test_case "Create directory if not exists"
test_config_dir="${TEST_DIR}/test_config"
ensure_dir "$test_config_dir"
if [[ -d "$test_config_dir" ]]; then
    pass
else
    fail "Directory creation failed"
fi

# ============================================
# Summary
# ============================================
echo ""
show_header "Test Summary"

echo "Tests run:             ${TESTS_RUN}"
echo "Tests passed:          ${TESTS_PASSED}"
echo "Tests failed:          ${TESTS_FAILED}"
echo ""

if [[ ${TESTS_FAILED} -eq 0 ]]; then
    success "All tests passed!"
    exit 0
else
    log_error "Some tests failed"
    exit 1
fi
