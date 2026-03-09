#!/usr/bin/env bash
#
# nsf - Constants
# Global constants and configuration
#

# Version
readonly NSF_VERSION="3.1.0"
readonly NSF_NAME="NSF - New Script File Creator"
readonly NSF_DESCRIPTION="Advanced shell script creator tool supporting 9 programming languages"

# Exit codes
readonly ERROR_SUCCESS=0
readonly ERROR_NO_EXTENSION=1
readonly ERROR_INVALID_EXTENSION=2
readonly ERROR_FILE_EXISTS=3
readonly ERROR_CREATION_FAILED=4
readonly ERROR_CONFIG_FAILED=5
readonly ERROR_INVALID_ARGS=6

# Exit codes for logging
readonly ERROR_INVALID_LEVEL=7
readonly ERROR_CONFIG_NOT_FOUND=8

# Supported extensions and languages
declare -rA SUPPORTED_EXTENSIONS=(
    [sh]="Bash/Shell"
    [bash]="Bash"
    [py]="Python 3"
    [js]="JavaScript"
    [ts]="TypeScript"
    [go]="Go"
    [rs]="Rust"
    [rb]="Ruby"
    [php]="PHP"
)

# Directory paths
NSF_TEMPLATES_DIR="${NSF_TEMPLATES_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/templates}"
NSF_CONFIG_DIR="${NSF_CONFIG_DIR:-$HOME/.config/nsf}"
NSF_CONFIG_FILE="${NSF_CONFIG_DIR}/nsf.conf"
NSF_CACHE_DIR="${NSF_CACHE_DIR:-$HOME/.cache/nsf}"

# Default configuration
DEFAULT_AUTHOR="${NSF_AUTHOR:-$(whoami)}"
DEFAULT_DATE_FORMAT="${NSF_DATE_FORMAT:-%Y-%m-%d}"
DEFAULT_EDITOR="${NSF_EDITOR:-${EDITOR:-nano}}"

# Permissions
readonly SCRIPT_PERMISSION=755

# Timeouts (in seconds)
readonly INPUT_TIMEOUT=5

# Color codes for output
readonly COLOR_RESET='\033[0m'
readonly COLOR_GREEN='\033[0;32m'
readonly COLOR_RED='\033[0;31m'
readonly COLOR_YELLOW='\033[1;33m'
readonly COLOR_BLUE='\033[0;34m'
readonly COLOR_CYAN='\033[0;36m'

# Log levels
readonly LOG_DEBUG=0
readonly LOG_INFO=1
readonly LOG_WARN=2
readonly LOG_ERROR=3

# Debug mode
DEBUG_MODE="${NSF_DEBUG:-false}"
