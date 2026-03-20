#!/usr/bin/env bash
# =============================================================================
# templates.sh — Template loader and preview functions
# This file NO LONGER contains hardcoded template content.
# All templates live as plain text files in templates/*.tmpl
# This file only contains functions that load, resolve, and display them.
# =============================================================================

# -----------------------------------------------------------------------------
# preview_template
# Reads the raw (unresolved) .tmpl file and prints it to stdout.
# Used by nsf --preview EXT to show the template before any substitution.
# Different from --dry-run, which shows the *resolved* output.
# $1 = extension (e.g. "py", "go", "sh")
# -----------------------------------------------------------------------------
preview_template() {
    local ext="$1"

    local tmpl_path
    tmpl_path=$(find_template "${ext}") || {
        log_error "No template found for extension: .${ext}"
        log_step  "Run 'nsf --list' to see supported types."
        return "${EXIT_NO_TEMPLATE}"
    }

    echo "${CLR_BOLD}Template for .${ext} (${NSF_SUPPORTED_EXTENSIONS[${ext}]:-unknown}):${CLR_RESET}"
    echo "${CLR_BLUE}$(printf '─%.0s' {1..56})${CLR_RESET}"
    cat "${tmpl_path}"
    echo "${CLR_BLUE}$(printf '─%.0s' {1..56})${CLR_RESET}"
}

# -----------------------------------------------------------------------------
# load_template_content
# Returns the fully resolved template content for a given file.
# This is the function called by core.sh during actual file creation.
# $1 = extension, $2 = filename, $3 = description
# Prints resolved content to stdout so callers can capture with $()
# -----------------------------------------------------------------------------
load_template_content() {
    local ext="$1"
    local filename="$2"
    local description="${3:-}"

    local tmpl_path
    tmpl_path=$(find_template "${ext}") || return "${EXIT_NO_TEMPLATE}"

    render_template "${tmpl_path}" "${filename}" "${description}"
}
