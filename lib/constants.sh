#!/usr/bin/env bash
# =============================================================================
# constants.sh — Global constants for nsf
# All readonly variables are defined here and sourced by every other module.
# Nothing in this file executes logic — it only sets values.
# =============================================================================

# -----------------------------------------------------------------------------
# Version
# -----------------------------------------------------------------------------
readonly NSF_VERSION="3.2.0"
readonly NSF_NAME="nsf"

# -----------------------------------------------------------------------------
# Paths — where nsf looks for things at runtime
# NSF_INSTALL_DIR is resolved from the real path of the running binary
# so the tool works correctly from symlinks (e.g. ~/.local/bin/nsf -> /opt/nsf/bin/nsf)
# -----------------------------------------------------------------------------
NSF_INSTALL_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && cd .. && pwd)"
readonly NSF_INSTALL_DIR

readonly NSF_TEMPLATE_DIR="${NSF_INSTALL_DIR}/templates"
readonly NSF_LIB_DIR="${NSF_INSTALL_DIR}/lib"

# User-level overrides — checked before system templates
readonly NSF_USER_CONFIG_DIR="${HOME}/.config/nsf"
NSF_USER_TEMPLATE_DIR="${NSF_USER_TEMPLATE_DIR:-${NSF_USER_CONFIG_DIR}/templates}"
readonly NSF_CONFIG_FILE="${NSF_USER_CONFIG_DIR}/nsf.conf"

# -----------------------------------------------------------------------------
# Defaults — all overridable via nsf.conf or environment variables
# -----------------------------------------------------------------------------
NSF_AUTHOR="${NSF_AUTHOR:-YOUR_NAME}"
NSF_DATE_FORMAT="${NSF_DATE_FORMAT:-%Y-%m-%d}"
NSF_EDITOR="${NSF_EDITOR:-${EDITOR:-vi}}"
NSF_LICENSE="${NSF_LICENSE:-MIT}"
NSF_DESCRIPTION="${NSF_DESCRIPTION:-}"
NSF_DEBUG="${NSF_DEBUG:-false}"

DEFAULT_MAKE_EXECUTABLE="${DEFAULT_MAKE_EXECUTABLE:-true}"
ENABLE_GIT_INTEGRATION="${ENABLE_GIT_INTEGRATION:-true}"
ENABLE_EDITOR_SELECTION="${ENABLE_EDITOR_SELECTION:-true}"
TIMEOUT_SECONDS="${TIMEOUT_SECONDS:-5}"

# -----------------------------------------------------------------------------
# Supported extensions — used by --list, completion scripts, and the loader
# Each entry maps "extension -> display name"
# The associative array requires Bash 4.0+
# -----------------------------------------------------------------------------
declare -A NSF_SUPPORTED_EXTENSIONS=(
    [sh]="Bash"
    [bash]="Bash"
    [py]="Python 3"
    [js]="JavaScript"
    [ts]="TypeScript"
    [go]="Go"
    [rs]="Rust"
    [rb]="Ruby"
    [php]="PHP"
    [c]="C"
    [cpp]="C++"
    [java]="Java"
)

# -----------------------------------------------------------------------------
# Exit codes — consistent codes used throughout the tool
# Using named constants makes error handling readable in core.sh
# -----------------------------------------------------------------------------
readonly EXIT_OK=0
readonly EXIT_ERR=1
readonly EXIT_USAGE=2
readonly EXIT_EXISTS=3
readonly EXIT_NO_TEMPLATE=4
