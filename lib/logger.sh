#!/usr/bin/env bash
# =============================================================================
# logger.sh — All terminal output, colours, and the --help display
# All user-facing text lives here. Nothing else should use echo directly.
# =============================================================================

# -----------------------------------------------------------------------------
# Colour codes
# tput is safer than hardcoding ANSI escapes — it reads the terminal's
# own capabilities. We check if stdout is a terminal first (-t 1) so
# colours are stripped cleanly when piping output to a file or another tool.
# -----------------------------------------------------------------------------
if [[ -t 1 ]]; then
    CLR_RED=$(tput setaf 1)
    CLR_GREEN=$(tput setaf 2)
    CLR_YELLOW=$(tput setaf 3)
    CLR_BLUE=$(tput setaf 4)
    CLR_CYAN=$(tput setaf 6)
    CLR_BOLD=$(tput bold)
    CLR_RESET=$(tput sgr0)
else
    CLR_RED="" CLR_GREEN="" CLR_YELLOW=""
    CLR_BLUE="" CLR_CYAN="" CLR_BOLD="" CLR_RESET=""
fi

# -----------------------------------------------------------------------------
# Core logging functions
# Each writes to the appropriate stream: errors go to stderr (>&2),
# everything else goes to stdout.
# -----------------------------------------------------------------------------

log_info() {
    echo "${CLR_GREEN}✓${CLR_RESET} $*"
}

log_warn() {
    echo "${CLR_YELLOW}⚠${CLR_RESET} $*"
}

log_error() {
    echo "${CLR_RED}✗${CLR_RESET} $*" >&2
}

log_step() {
    echo "${CLR_BLUE}→${CLR_RESET} $*"
}

log_debug() {
    if [[ "${NSF_DEBUG}" == "true" ]]; then
        echo "${CLR_CYAN}[debug]${CLR_RESET} $*" >&2
    fi
}

log_blank() {
    echo ""
}

# -----------------------------------------------------------------------------
# Divider line — used in the success summary box
# -----------------------------------------------------------------------------
log_divider() {
    echo "${CLR_BLUE}$(printf '═%.0s' {1..56})${CLR_RESET}"
}

# -----------------------------------------------------------------------------
# Success summary — printed after a file is created successfully
# $1 = file path, $2 = language, $3 = author, $4 = date
# -----------------------------------------------------------------------------
log_success_box() {
    local filepath="$1"
    local language="$2"
    local author="$3"
    local date="$4"

    log_blank
    log_divider
    echo "  ${CLR_GREEN}${CLR_BOLD}✓ Script Created Successfully${CLR_RESET}"
    log_blank
    printf "  %-12s %s\n" "File:" "${CLR_BOLD}${filepath}${CLR_RESET}"
    printf "  %-12s %s\n" "Language:" "${language}"
    printf "  %-12s %s\n" "Author:" "${author}"
    printf "  %-12s %s\n" "Created:" "${date}"
    log_divider
    log_blank
}

# -----------------------------------------------------------------------------
# Batch summary — printed after nsf runs on multiple files at once
# $1 = space-separated list of "filename:status" pairs
# -----------------------------------------------------------------------------
log_batch_summary() {
    local -a results=("$@")
    local passed=0
    local failed=0
    local skipped=0

    log_blank
    log_divider
    echo "  ${CLR_BOLD}Batch Summary${CLR_RESET}"
    log_blank

    for entry in "${results[@]}"; do
        local file="${entry%%:*}"
        local status="${entry##*:}"
        case "${status}" in
            ok)
                printf "  ${CLR_GREEN}✓${CLR_RESET} %-30s %s\n" "${file}" "created"
                passed=$(( passed + 1 )) ;;
            skip)
                printf "  ${CLR_YELLOW}~${CLR_RESET} %-30s %s\n" "${file}" "skipped (exists)"
                skipped=$(( skipped + 1 )) ;;
            fail)
                printf "  ${CLR_RED}✗${CLR_RESET} %-30s %s\n" "${file}" "failed"
                failed=$(( failed + 1 )) ;;
        esac
    done

    log_blank
    printf "  Created: ${CLR_GREEN}%d${CLR_RESET}  Skipped: ${CLR_YELLOW}%d${CLR_RESET}  Failed: ${CLR_RED}%d${CLR_RESET}\n" \
        "${passed}" "${skipped}" "${failed}"
    log_divider
    log_blank
}

# -----------------------------------------------------------------------------
# --help output
# Structured into four sections: USAGE, OPTIONS, EXAMPLES, CONFIG
# Two-column alignment is achieved with printf "%-N" padding.
# -----------------------------------------------------------------------------
show_help() {
    cat << EOF
${CLR_BOLD}${NSF_NAME} ${NSF_VERSION}${CLR_RESET} — New Script File creator

${CLR_BOLD}USAGE${CLR_RESET}
  ${CLR_CYAN}nsf${CLR_RESET} [options] <filename> [filename ...]

${CLR_BOLD}OPTIONS${CLR_RESET}
  $(printf "%-28s" "${CLR_CYAN}-h, --help${CLR_RESET}")    Show this help message
  $(printf "%-28s" "${CLR_CYAN}-v, --version${CLR_RESET}")  Show version number
  $(printf "%-28s" "${CLR_CYAN}-l, --list${CLR_RESET}")     List all supported file types
  $(printf "%-28s" "${CLR_CYAN}-p, --preview EXT${CLR_RESET}")  Preview raw template for extension
  $(printf "%-28s" "${CLR_CYAN}-c, --config${CLR_RESET}")   Show active configuration
  $(printf "%-28s" "${CLR_CYAN}-d, --debug FILE${CLR_RESET}")   Create file with verbose debug output
  $(printf "%-28s" "${CLR_CYAN}-n, --dry-run${CLR_RESET}")  Show what would be created, create nothing
  $(printf "%-28s" "${CLR_CYAN}-f, --force${CLR_RESET}")    Overwrite existing file (with confirmation)
  $(printf "%-28s" "${CLR_CYAN}-b, --backup${CLR_RESET}")   Back up existing file before overwriting
  $(printf "%-28s" "${CLR_CYAN}-D, --desc TEXT${CLR_RESET}")  Set description injected into template

${CLR_BOLD}EXAMPLES${CLR_RESET}
  ${CLR_GREEN}nsf deploy.sh${CLR_RESET}                    Create a bash script
  ${CLR_GREEN}nsf api.go server.go client.go${CLR_RESET}   Create three Go files at once
  ${CLR_GREEN}nsf --dry-run main.py${CLR_RESET}            Preview resolved output without creating
  ${CLR_GREEN}nsf --desc "REST API" --force api.py${CLR_RESET}  Overwrite with a description set
  ${CLR_GREEN}nsf --preview ts${CLR_RESET}                 Show the raw TypeScript template
  ${CLR_GREEN}nsf --backup config.sh${CLR_RESET}           Back up existing file then overwrite

${CLR_BOLD}SUPPORTED LANGUAGES${CLR_RESET}
  .sh .bash  Bash       .py   Python 3    .js   JavaScript
  .ts        TypeScript  .go   Go          .rs   Rust
  .rb        Ruby        .php  PHP         .c    C
  .cpp       C++         .java Java

${CLR_BOLD}CONFIGURATION${CLR_RESET}
  Config file: ${CLR_CYAN}~/.config/nsf/nsf.conf${CLR_RESET}
  User templates: ${CLR_CYAN}~/.config/nsf/templates/EXT.tmpl${CLR_RESET}
  Run ${CLR_CYAN}nsf --config${CLR_RESET} to see all active values.
EOF
}

# -----------------------------------------------------------------------------
# --version output
# -----------------------------------------------------------------------------
show_version() {
    echo "${NSF_NAME} ${NSF_VERSION}"
}

# -----------------------------------------------------------------------------
# --list output
# Iterates NSF_SUPPORTED_EXTENSIONS from constants.sh
# -----------------------------------------------------------------------------
show_list() {
    echo "${CLR_BOLD}Supported file types:${CLR_RESET}"
    log_blank

    # Sort the extensions alphabetically for consistent display
    local ext
    for ext in $(echo "${!NSF_SUPPORTED_EXTENSIONS[@]}" | tr ' ' '\n' | sort); do
        printf "  ${CLR_CYAN}.%-8s${CLR_RESET} %s\n" "${ext}" "${NSF_SUPPORTED_EXTENSIONS[${ext}]}"
    done
    log_blank
}

# -----------------------------------------------------------------------------
# --config output
# Shows every active value, indicating the source (config file vs default)
# -----------------------------------------------------------------------------
show_config() {
    echo "${CLR_BOLD}Active configuration:${CLR_RESET}"
    log_blank
    printf "  %-28s %s\n" "Config file:"      "${NSF_CONFIG_FILE}"
    printf "  %-28s %s\n" "NSF_AUTHOR:"        "${NSF_AUTHOR}"
    printf "  %-28s %s\n" "NSF_DATE_FORMAT:"   "${NSF_DATE_FORMAT}"
    printf "  %-28s %s\n" "NSF_EDITOR:"        "${NSF_EDITOR}"
    printf "  %-28s %s\n" "NSF_LICENSE:"       "${NSF_LICENSE}"
    printf "  %-28s %s\n" "NSF_DESCRIPTION:"   "${NSF_DESCRIPTION:-(not set)}"
    printf "  %-28s %s\n" "NSF_DEBUG:"         "${NSF_DEBUG}"
    printf "  %-28s %s\n" "MAKE_EXECUTABLE:"   "${DEFAULT_MAKE_EXECUTABLE}"
    printf "  %-28s %s\n" "GIT_INTEGRATION:"   "${ENABLE_GIT_INTEGRATION}"
    printf "  %-28s %s\n" "EDITOR_SELECTION:"  "${ENABLE_EDITOR_SELECTION}"
    printf "  %-28s %s\n" "System templates:"  "${NSF_TEMPLATE_DIR}"
    printf "  %-28s %s\n" "User templates:"    "${NSF_USER_TEMPLATE_DIR}"
    log_blank
}
