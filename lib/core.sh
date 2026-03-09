#!/usr/bin/env bash
#
# nsf - Core Functions
# Main logic for script creation
#

# Initialize nsf
init_nsf() {
    init_logger
    load_config
    init_config || return 1
    ensure_dir "$NSF_TEMPLATES_DIR" || return 1
    ensure_dir "$NSF_CONFIG_DIR" || return 1
}

# Create new script file
create_script() {
    local filename="$1"
    local extension
    local author
    local date_created
    local template_content
    
    extension=$(get_extension "$filename")
    if [[ -z "$extension" ]]; then
        error_exit "No file extension provided. Supported: $(get_supported_extensions)" "$ERROR_NO_EXTENSION"
    fi
    
    if ! validate_extension "$extension"; then
        error_exit "Unsupported extension: .$extension. Supported: $(get_supported_extensions)" "$ERROR_INVALID_EXTENSION"
    fi
    
    debug "Using .$extension template"
    
    author="${DEFAULT_AUTHOR:-$(whoami)}"
    date_created="$(date +"${DEFAULT_DATE_FORMAT:-%Y-%m-%d}" 2>/dev/null || echo 'unknown')"
    
    debug "Author: $author, Date: $date_created"
    
    if [[ -f "$filename" ]]; then
        log_warn "File '$filename' already exists"
        read -t "$INPUT_TIMEOUT" -p "Overwrite? (y/n) " -n 1 choice
        echo
        [[ "$choice" != "y" && "$choice" != "Y" ]] && {
            log_warn "Cancelled"
            return 1
        }
    fi
    
    template_content=$(get_template "$extension" "$author" "$date_created")
    if [[ -z "$template_content" ]]; then
        error_exit "Failed to get template for .$extension" "$ERROR_TEMPLATE_NOT_FOUND"
    fi
    
    debug "Template content length: ${#template_content}"
    
    if echo "$template_content" > "$filename"; then
        if [[ "$extension" != "js" ]] && [[ "$extension" != "html" ]]; then
            chmod +x "$filename" 2>/dev/null || true
        fi
        
        log_info "Creating $(get_language_name "$extension") script: $filename"
        success "Script created: $filename"
        return 0
    else
        error_exit "Failed to write file: $filename" "$ERROR_CREATION_FAILED"
    fi
}

# Show help information
show_help() {
    cat <<'HELP'
nsf - New Script File Creator

USAGE:
  nsf <filename>           Create a new script file
  nsf --list               List available templates
  nsf --preview <ext>      Preview a template
  nsf --help               Show this help message
  nsf --version            Show version information
  nsf --config             Show configuration

OPTIONS:
  -h, --help               Display this help message
  -v, --version            Display version information
  -l, --list               List all supported templates
  -p, --preview <ext>      Preview template for extension
  -c, --config             Show current configuration
  -d, --debug              Enable debug mode

EXAMPLES:
  nsf script.sh            Create a bash script
  nsf hello.py             Create a Python script
  nsf app.js               Create a JavaScript file
  nsf --list               See all available templates
  nsf --preview py         Preview Python template

SUPPORTED EXTENSIONS:
  sh, bash, py, js, ts, go, rs, rb, php

For more information, visit:
  https://github.com/Varenya-Sawant/nsf
HELP
}

# Show version information
show_version() {
    cat <<EOF
$NSF_NAME version $NSF_VERSION
$NSF_DESCRIPTION

Author: $DEFAULT_AUTHOR
EOF
}

# Show configuration
show_configuration() {
    show_header "Configuration"
    
    cat << EOF
Version: $NSF_VERSION
Author: $DEFAULT_AUTHOR
Date Format: $DEFAULT_DATE_FORMAT
Editor: $DEFAULT_EDITOR
Debug Mode: $DEBUG_MODE
Config File: $NSF_CONFIG_FILE
Templates Directory: $NSF_TEMPLATES_DIR
Cache Directory: $NSF_CACHE_DIR

Supported Extensions: $(get_supported_extensions)

EOF
}
