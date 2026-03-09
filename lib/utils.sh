#!/usr/bin/env bash
#
# nsf - Utilities
# Helper functions
#

# Get file extension
get_extension() {
    local filename="$1"
    local extension="${filename##*.}"
    
    # If no extension found, return empty
    if [[ "$extension" == "$filename" ]]; then
        echo ""
    else
        echo "$extension"
    fi
}

# Get supported extensions as comma-separated list
get_supported_extensions() {
    local extensions=()
    for ext in "${!SUPPORTED_EXTENSIONS[@]}"; do
        extensions+=(".$ext")
    done
    
    IFS=',' read -ra sorted <<< "$(printf '%s\n' "${extensions[@]}" | sort | paste -sd ',' -)"
    echo "$sorted"
}

# Validate file extension
validate_extension() {
    local extension="$1"
    
    # Remove leading dot if present
    extension="${extension#.}"
    
    [[ -v SUPPORTED_EXTENSIONS["$extension"] ]]
}

# Check if file already exists
check_file_exists() {
    local filename="$1"
    
    if [[ -f "$filename" ]]; then
        log_warn "File '$filename' already exists"
        read -t "$INPUT_TIMEOUT" -p "Overwrite? (y/n) " -n 1 choice
        echo
        
        case "$choice" in
            y|Y)
                log_info "Overwriting existing file..."
                return 0
                ;;
            *)
                log_warn "Cancelled"
                return 1
                ;;
        esac
    fi
    return 0
}

# Ensure directory exists
ensure_dir() {
    local dir="$1"
    
    if [[ ! -d "$dir" ]]; then
        debug "Creating directory: $dir"
        mkdir -p "$dir" 2>/dev/null || {
            log_error "Failed to create directory: $dir"
            return 1
        }
    fi
    return 0
}

# Make file executable
make_executable() {
    local filename="$1"
    
    if chmod +x "$filename" 2>/dev/null; then
        debug "Made $filename executable"
        return 0
    else
        log_warn "Failed to make $filename executable"
        return 1
    fi
}

# Load configuration file
load_config() {
    if [[ -f "$NSF_CONFIG_FILE" ]]; then
        debug "Loading configuration from: $NSF_CONFIG_FILE"
        # shellcheck source=/dev/null
        source "$NSF_CONFIG_FILE" || {
            log_warn "Failed to load configuration file"
            return 1
        }
        return 0
    fi
    return 0
}

# Initialize configuration
init_config() {
    ensure_dir "$NSF_CONFIG_DIR" || return 1
    
    if [[ ! -f "$NSF_CONFIG_FILE" ]]; then
        debug "Creating default configuration"
        create_default_config
    fi
    return 0
}

# Create default configuration file
create_default_config() {
    cat > "$NSF_CONFIG_FILE" << 'EOF'
# NSF Configuration File
# ~/.config/nsf/nsf.conf

# Default author name (if not set, uses system username)
# NSF_AUTHOR="Your Name"

# Date format (strftime syntax)
# NSF_DATE_FORMAT="%Y-%m-%d"

# Preferred editor
# NSF_EDITOR="nano"

# Enable debug mode
# NSF_DEBUG="false"

# Custom template directory (if needed)
# NSF_TEMPLATES_DIR=""
EOF
    debug "Created default configuration at: $NSF_CONFIG_FILE"
}

# Get template language name
get_language_name() {
    local extension="$1"
    extension="${extension#.}"
    echo "${SUPPORTED_EXTENSIONS[$extension]:-Unknown}"
}

# Command exists check
command_exists() {
    local cmd="$1"
    command -v "$cmd" >/dev/null 2>&1
}

# Validate script syntax (for shell scripts)
validate_syntax() {
    local filename="$1"
    local extension="$2"
    
    if [[ "$extension" == "sh" ]] || [[ "$extension" == "bash" ]]; then
        if bash -n "$filename" 2>/dev/null; then
            return 0
        else
            log_warn "Script has syntax errors"
            return 1
        fi
    fi
    return 0
}

# Prompt for user input with timeout
prompt_input() {
    local prompt="$1"
    local default="${2:-}"
    local response
    
    if [[ -n "$default" ]]; then
        read -t "$INPUT_TIMEOUT" -p "$prompt [$default]: " response
    else
        read -t "$INPUT_TIMEOUT" -p "$prompt: " response
    fi
    
    # If timeout or empty, use default
    if [[ -z "$response" ]]; then
        echo "$default"
    else
        echo "$response"
    fi
}
