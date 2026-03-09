#!/usr/bin/env bash
#
# nsf - Logger
# Logging and output formatting
#

# Initialize logger
init_logger() {
    # Create cache directory for logs if needed
    if [[ "$DEBUG_MODE" == "true" ]]; then
        mkdir -p "$NSF_CACHE_DIR" 2>/dev/null || true
        LOG_FILE="$NSF_CACHE_DIR/nsf.log"
    fi
}

# Log debug message
debug() {
    local message="$1"
    [[ "$DEBUG_MODE" != "true" ]] && return 0
    
    echo "[DEBUG] $message" >&2
    [[ -n "${LOG_FILE:-}" ]] && echo "[$(date +'%Y-%m-%d %H:%M:%S')] [DEBUG] $message" >> "$LOG_FILE"
}

# Log info message
log_info() {
    local message="$1"
    echo -e "${COLOR_BLUE}[✓]${COLOR_RESET} $message"
    [[ -n "${LOG_FILE:-}" ]] && echo "[$(date +'%Y-%m-%d %H:%M:%S')] [INFO] $message" >> "$LOG_FILE"
}

# Log warning message
log_warn() {
    local message="$1"
    echo -e "${COLOR_YELLOW}[!]${COLOR_RESET} $message" >&2
    [[ -n "${LOG_FILE:-}" ]] && echo "[$(date +'%Y-%m-%d %H:%M:%S')] [WARN] $message" >> "$LOG_FILE"
}

# Log error message
log_error() {
    local message="$1"
    echo -e "${COLOR_RED}[✗]${COLOR_RESET} $message" >&2
    [[ -n "${LOG_FILE:-}" ]] && echo "[$(date +'%Y-%m-%d %H:%M:%S')] [ERROR] $message" >> "$LOG_FILE"
}

# Exit with error
error_exit() {
    local message="$1"
    local exit_code="${2:-$ERROR_CREATION_FAILED}"
    
    log_error "$message"
    exit "$exit_code"
}

# Display success message
success() {
    local message="$1"
    echo -e "${COLOR_GREEN}[✓]${COLOR_RESET} ${COLOR_GREEN}$message${COLOR_RESET}"
    [[ -n "${LOG_FILE:-}" ]] && echo "[$(date +'%Y-%m-%d %H:%M:%S')] [SUCCESS] $message" >> "$LOG_FILE"
}

# Display header
show_header() {
    local title="$1"
    echo
    echo -e "${COLOR_CYAN}═══════════════════════════════════════${COLOR_RESET}"
    echo -e "${COLOR_CYAN}  $title${COLOR_RESET}"
    echo -e "${COLOR_CYAN}═══════════════════════════════════════${COLOR_RESET}"
    echo
}

# Display section
show_section() {
    local title="$1"
    echo -e "\n${COLOR_BLUE}### $title${COLOR_RESET}"
}

# Display help text
show_help() {
    show_header "$NSF_NAME"
    
    cat << 'EOF'
Usage: nsf [OPTIONS] [filename]

COMMANDS:
  nsf filename          Create a new script file (auto-detect language)
  nsf --help, -h        Show this help message
  nsf --version, -v     Show version information
  nsf --list, -l        List supported templates
  nsf --preview, -p EXT Show template preview for extension
  nsf --config, -c      Show current configuration
  nsf --debug, -d FILE  Create file in debug mode (verbose output)

EXAMPLES:
  nsf script.sh         Create a Bash script
  nsf app.py            Create a Python script
  nsf main.js           Create a JavaScript file
  nsf -p py             Preview Python template
  nsf --list            List all supported languages

ENVIRONMENT VARIABLES:
  NSF_AUTHOR            Set default author name
  NSF_DATE_FORMAT       Set date format (strftime syntax)
  NSF_EDITOR            Set preferred editor (vim, nano, etc)
  NSF_DEBUG             Enable debug mode (true/false)

CONFIGURATION:
  Config file: ~/.config/nsf/nsf.conf

For more information, visit: https://github.com/Varenya-Sawant/nsf

EOF
}

# Display version
show_version() {
    echo "$NSF_NAME"
    echo "Version $NSF_VERSION"
    echo "License: MIT"
}
