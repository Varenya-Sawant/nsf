#!/usr/bin/env bash
# =============================================================================
# utils.sh — Utility functions used across the tool
# Includes: config loading, variable substitution engine, git helpers,
# editor prompt, extension detection, and overwrite handling.
# =============================================================================

# -----------------------------------------------------------------------------
# load_config
# Reads ~/.config/nsf/nsf.conf if it exists and sources it.
# Variables set in the config file override the defaults in constants.sh,
# but environment variables set before running nsf override the config file
# (because we use := assignment — "set only if not already set" — in constants.sh).
# -----------------------------------------------------------------------------
load_config() {
    if [[ -f "${NSF_CONFIG_FILE}" ]]; then
        # shellcheck source=/dev/null
        source "${NSF_CONFIG_FILE}"
        log_debug "Config loaded from ${NSF_CONFIG_FILE}"
    else
        log_debug "No config file found at ${NSF_CONFIG_FILE}, using defaults"
    fi
}

# -----------------------------------------------------------------------------
# check_bash_version
# nsf requires Bash 4.0+ for associative arrays (declare -A).
# macOS ships Bash 3.2 by default — this check gives a clear error
# instead of a cryptic "declare: -A: invalid option" message.
# -----------------------------------------------------------------------------
check_bash_version() {
    if [[ "${BASH_VERSINFO[0]}" -lt 4 ]]; then
        echo "✗ nsf requires Bash 4.0 or higher." >&2
        echo "  Your version: ${BASH_VERSION}" >&2
        echo "" >&2
        echo "  On macOS, install a newer bash with:" >&2
        echo "    brew install bash" >&2
        echo "  Then add /usr/local/bin/bash (or /opt/homebrew/bin/bash) to /etc/shells" >&2
        exit 1
    fi
}

# -----------------------------------------------------------------------------
# get_extension
# Extracts the lowercase extension from a filename.
# "api.Go" -> "go",  "script.SH" -> "sh",  "noext" -> ""
# -----------------------------------------------------------------------------
get_extension() {
    local filename="$1"
    local ext="${filename##*.}"     # strip everything up to last dot
    if [[ "${ext}" == "${filename}" ]]; then
        echo ""                     # no dot found — no extension
    else
        echo "${ext,,}"             # ${var,,} lowercases the string (Bash 4+)
    fi
}

# -----------------------------------------------------------------------------
# get_basename
# Strips extension from filename for use in template tokens.
# "api.go" -> "api",  "my_script.sh" -> "my_script"
# -----------------------------------------------------------------------------
get_basename() {
    local filename="$1"
    echo "${filename%.*}"
}

# -----------------------------------------------------------------------------
# is_supported_extension
# Returns 0 (true) if the extension is in NSF_SUPPORTED_EXTENSIONS, 1 if not.
# Used before attempting template lookup.
# -----------------------------------------------------------------------------
is_supported_extension() {
    local ext="$1"
    [[ -n "${NSF_SUPPORTED_EXTENSIONS[${ext}]+_}" ]]
}

# -----------------------------------------------------------------------------
# substitute_variables
# The template variable engine. Reads template content from stdin,
# replaces all {{TOKEN}} placeholders, writes resolved content to stdout.
#
# How it works: sed's -e flag chains multiple substitution expressions.
# Each s|{{TOKEN}}|value|g replaces all occurrences of that token.
# We use | as delimiter (not /) so file paths containing / don't break it.
# The 'g' flag at the end replaces ALL occurrences on each line.
#
# $1 = author, $2 = date, $3 = filename, $4 = basename, $5 = license, $6 = description
# -----------------------------------------------------------------------------
substitute_variables() {
    local author="$1"
    local date="$2"
    local filename="$3"
    local basename="$4"
    local license="$5"
    local description="$6"

    sed \
        -e "s|{{NSF_AUTHOR}}|${author}|g" \
        -e "s|{{NSF_DATE}}|${date}|g" \
        -e "s|{{NSF_FILENAME}}|${filename}|g" \
        -e "s|{{NSF_BASENAME}}|${basename}|g" \
        -e "s|{{NSF_LICENSE}}|${license}|g" \
        -e "s|{{NSF_DESCRIPTION}}|${description}|g"
}

# -----------------------------------------------------------------------------
# find_template
# Resolves the path to the correct .tmpl file for a given extension.
# Lookup order: user templates dir → system templates dir → not found
# This is what allows users to override any built-in template.
# Prints the resolved path to stdout. Returns 1 if no template found.
# -----------------------------------------------------------------------------
find_template() {
    local ext="$1"

    # Normalise sh and bash to the same template
    [[ "${ext}" == "bash" ]] && ext="sh"

    local user_tmpl="${NSF_USER_TEMPLATE_DIR}/${ext}.tmpl"
    local sys_tmpl="${NSF_TEMPLATE_DIR}/${ext}.tmpl"

    if [[ -f "${user_tmpl}" ]]; then
        log_debug "Using user template: ${user_tmpl}"
        echo "${user_tmpl}"
    elif [[ -f "${sys_tmpl}" ]]; then
        log_debug "Using system template: ${sys_tmpl}"
        echo "${sys_tmpl}"
    else
        return 1
    fi
}

# -----------------------------------------------------------------------------
# render_template
# Reads a .tmpl file and runs substitution_variables on its content.
# Prints the fully resolved file content to stdout.
# Callers either write this to a file or display it (dry-run / preview).
# -----------------------------------------------------------------------------
render_template() {
    local tmpl_path="$1"
    local filename="$2"
    local description="${3:-}"

    local author date basename license

    author="${NSF_AUTHOR}"
    date=$(date +"${NSF_DATE_FORMAT}")
    basename=$(get_basename "${filename}")
    license="${NSF_LICENSE}"

    # For Java: class name must be PascalCase of the basename
    # We handle this by also providing NSF_BASENAME_PASCAL as a bonus token
    # e.g. "my_api" -> "MyApi"  (used in java.tmpl)
    local pascal_basename
    # Pure bash PascalCase — works on Linux and macOS (no GNU sed needed)
    pascal_basename=""
    IFS='_' read -ra parts <<< "${basename}"
    for part in "${parts[@]}"; do
        if [[ -n "${part}" ]]; then
            pascal_basename+="${part^}"
        fi
    done

    substitute_variables \
        "${author}" \
        "${date}" \
        "${filename}" \
        "${basename}" \
        "${license}" \
        "${description}" \
        < "${tmpl_path}" \
        | sed "s|{{NSF_BASENAME_PASCAL}}|${pascal_basename}|g"
}

# -----------------------------------------------------------------------------
# handle_existing_file
# Called when nsf is about to create a file that already exists.
# Behaviour depends on flags:
#   default  → abort with EXIT_EXISTS
#   --force  → prompt for confirmation, then allow overwrite
#   --backup → rename existing to filename.bak, then allow overwrite
# Returns 0 to proceed, exits non-zero to abort.
# $1=filepath, $2=force_flag, $3=backup_flag
# -----------------------------------------------------------------------------
handle_existing_file() {
    local filepath="$1"
    local force="${2:-false}"
    local backup="${3:-false}"

    if [[ "${backup}" == "true" ]]; then
        local backup_path="${filepath}.bak"
        mv "${filepath}" "${backup_path}"
        log_warn "Existing file backed up to ${backup_path}"
        return 0
    fi

    if [[ "${force}" == "true" ]]; then
        # Read from /dev/tty so this works even when stdin is redirected
        local reply
        read -r -p "  Overwrite ${filepath}? [y/N] " reply </dev/tty
        if [[ "${reply,,}" == "y" ]]; then
            return 0
        else
            log_warn "Skipped ${filepath}"
            return "${EXIT_EXISTS}"
        fi
    fi

    # Default: refuse
    log_error "File already exists: ${filepath}"
    log_step  "Use --force to overwrite, --backup to save a copy first."
    return "${EXIT_EXISTS}"
}

# -----------------------------------------------------------------------------
# make_executable
# Runs chmod +x on the file if DEFAULT_MAKE_EXECUTABLE is true AND the
# language is a scripting language (not Go, Java, C, C++, Rust, TS source).
# -----------------------------------------------------------------------------
make_executable() {
    local filepath="$1"
    local ext="$2"

    local -a script_langs=("sh" "bash" "py" "rb" "php" "js")
    local lang
    for lang in "${script_langs[@]}"; do
        if [[ "${ext}" == "${lang}" ]]; then
            chmod +x "${filepath}"
            log_debug "chmod +x applied to ${filepath}"
            return 0
        fi
    done
}

# -----------------------------------------------------------------------------
# git_add_file
# Runs git add on the new file if ENABLE_GIT_INTEGRATION is true AND
# we're inside a git repository. Silently skips if not in a repo.
# -----------------------------------------------------------------------------
git_add_file() {
    local filepath="$1"

    [[ "${ENABLE_GIT_INTEGRATION}" != "true" ]] && return 0

    # git rev-parse exits non-zero if not in a repo — we suppress output
    if git rev-parse --git-dir > /dev/null 2>&1; then
        if git add "${filepath}" 2>/dev/null; then
            log_info "Added to git"
        fi
    else
        log_debug "Not in a git repo, skipping git add"
    fi
}

# -----------------------------------------------------------------------------
# prompt_editor
# Offers to open the newly created file in an editor.
# Reads from /dev/tty so it works even when nsf is called in a pipeline.
# Respects ENABLE_EDITOR_SELECTION and TIMEOUT_SECONDS from config.
# -----------------------------------------------------------------------------
prompt_editor() {
    local filepath="$1"

    [[ "${ENABLE_EDITOR_SELECTION}" != "true" ]] && return 0

    local reply
    printf "Open with (1=Vim  2=Nano  3=Skip)? [3]: "
    # -t reads with a timeout so scripts using nsf don't hang forever
    read -r -t "${TIMEOUT_SECONDS}" reply </dev/tty || reply="3"

    case "${reply}" in
        1) vim  "${filepath}" ;;
        2) nano "${filepath}" ;;
        *) return 0 ;;
    esac
}
