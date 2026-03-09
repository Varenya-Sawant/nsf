#!/usr/bin/env bash
#
# nsf - Templates
# Template management and generation
#

# Generate script file from template
generate_script() {
    local filename="$1"
    local extension="$2"
    local author="$3"
    local date_created="$4"
    
    debug "Generating script: $filename (ext: $extension)"
    
    # Get template content
    local template_content
    template_content=$(get_template "$extension" "$author" "$date_created") || {
        log_error "Failed to get template for .$extension"
        return 1
    }
    
    # Write content to file
    if echo "$template_content" > "$filename"; then
        debug "File written: $filename"
        
        # Make executable
        if [[ "$extension" != "js" ]] && [[ "$extension" != "php" ]] && [[ "$extension" != "html" ]]; then
            make_executable "$filename"
        fi
        
        # Validate syntax if applicable
        validate_syntax "$filename" "$extension"
        
        success "Created $filename ($(get_language_name "$extension"))"
        
        # Ask to open in editor
        ask_open_editor "$filename" "$author"
        return 0
    else
        log_error "Failed to write file: $filename"
        return 1
    fi
}

# Get template content for extension
get_template() {
    local extension="$1"
    local author="$2"
    local date_created="$3"
    
    case "$extension" in
        sh|bash)
            get_template_bash "$author" "$date_created"
            ;;
        py)
            get_template_python "$author" "$date_created"
            ;;
        js)
            get_template_javascript "$author" "$date_created"
            ;;
        ts)
            get_template_typescript "$author" "$date_created"
            ;;
        go)
            get_template_go "$author" "$date_created"
            ;;
        rs)
            get_template_rust "$author" "$date_created"
            ;;
        rb)
            get_template_ruby "$author" "$date_created"
            ;;
        php)
            get_template_php "$author" "$date_created"
            ;;
        *)
            log_error "Unknown extension: $extension"
            return 1
            ;;
    esac
}

# Bash/Shell template
get_template_bash() {
    local author="$1"
    local date="$2"
    
    cat << 'EOF'
#!/usr/bin/env bash

#
# Script description
# 
# Author: AUTHOR
# Date: DATE
# Version: 1.0
#

set -euo pipefail

# Color codes
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m' # No Color

# Script directory
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Error handler
error_exit() {
    echo -e "${RED}Error: $1${NC}" >&2
    exit 1
}

# Main function
main() {
    echo "Script started..."
    # Add your code here
    echo "Script completed successfully!"
}

# Trap errors
trap 'error_exit "Script failed at line $LINENO"' ERR

# Run main
main "$@"
EOF
}

# Python template
get_template_python() {
    local author="$1"
    local date="$2"
    
    cat << 'EOF'
#!/usr/bin/env python3
"""
Script description

Author: AUTHOR
Date: DATE
Version: 1.0
"""

import sys
import logging

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)


def main():
    """Main function"""
    logger.info("Script started...")
    # Add your code here
    logger.info("Script completed successfully!")


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        logger.info("Script interrupted by user")
        sys.exit(130)
    except Exception as e:
        logger.error(f"Error: {e}", exc_info=True)
        sys.exit(1)
EOF
}

# JavaScript template
get_template_javascript() {
    local author="$1"
    local date="$2"
    
    cat << 'EOF'
/**
 * Script description
 * 
 * Author: AUTHOR
 * Date: DATE
 * Version: 1.0
 */

'use strict';

/**
 * Main function
 */
async function main() {
    try {
        console.log('Script started...');
        // Add your code here
        console.log('Script completed successfully!');
    } catch (error) {
        console.error('Error:', error);
        process.exit(1);
    }
}

// Run main function
main();
EOF
}

# TypeScript template
get_template_typescript() {
    local author="$1"
    local date="$2"
    
    cat << 'EOF'
/**
 * Script description
 * 
 * Author: AUTHOR
 * Date: DATE
 * Version: 1.0
 */

'use strict';

/**
 * Main function
 */
async function main(): Promise<void> {
    try {
        console.log('Script started...');
        // Add your code here
        console.log('Script completed successfully!');
    } catch (error) {
        console.error('Error:', error);
        process.exit(1);
    }
}

// Run main function
main();
EOF
}

# Go template
get_template_go() {
    local author="$1"
    local date="$2"
    
    cat << 'EOF'
package main

import (
	"fmt"
	"log"
	"os"
)

// Version of the application
const Version = "1.0"

func main() {
	if err := run(); err != nil {
		log.Fatalf("Error: %v", err)
	}
}

func run() error {
	fmt.Println("Script started...")
	// Add your code here
	fmt.Println("Script completed successfully!")
	return nil
}
EOF
}

# Rust template
get_template_rust() {
    local author="$1"
    local date="$2"
    
    cat << 'EOF'
//!
//! Script description
//!
//! Author: AUTHOR
//! Date: DATE
//! Version: 1.0
//!

use std::process;

const VERSION: &str = "1.0";

fn main() {
    if let Err(e) = run() {
        eprintln!("Error: {}", e);
        process::exit(1);
    }
}

fn run() -> Result<(), Box<dyn std::error::Error>> {
    println!("Script started...");
    // Add your code here
    println!("Script completed successfully!");
    Ok(())
}
EOF
}

# Ruby template
get_template_ruby() {
    local author="$1"
    local date="$2"
    
    cat << 'EOF'
#!/usr/bin/env ruby

#
# Script description
#
# Author: AUTHOR
# Date: DATE
# Version: 1.0
#

require 'logger'

# Setup logger
logger = Logger.new($stdout)
logger.level = Logger::INFO

def main(logger)
  logger.info 'Script started...'
  # Add your code here
  logger.info 'Script completed successfully!'
end

begin
  main(logger)
rescue Interrupt
  puts "\nScript interrupted by user"
  exit 130
rescue => e
  puts "Error: #{e}"
  exit 1
end
EOF
}

# PHP template
get_template_php() {
    local author="$1"
    local date="$2"
    
    cat << 'EOF'
<?php

/**
 * Script description
 *
 * Author: AUTHOR
 * Date: DATE
 * Version: 1.0
 */

declare(strict_types=1);

function main(): int
{
    echo "Script started...\n";
    // Add your code here
    echo "Script completed successfully!\n";
    return 0;
}

try {
    exit(main());
} catch (Throwable $e) {
    fprintf(STDERR, "Error: %s\n", $e->getMessage());
    exit(1);
}
?>
EOF
}

# List all templates
list_templates() {
    show_header "Supported Templates"
    
    printf "%-10s %s\n" "Extension" "Language"
    echo "─────────────────────────────────"
    
    for ext in "${!SUPPORTED_EXTENSIONS[@]}"; do
        printf "%-10s %s\n" ".$ext" "${SUPPORTED_EXTENSIONS[$ext]}"
    done | sort
    
    echo
    echo "Use 'nsf --preview <ext>' to preview a template"
}

# Preview template
preview_template() {
    local extension="$1"
    extension="${extension#.}"
    
    if ! validate_extension "$extension"; then
        error_exit "Unsupported extension: .$extension" "$ERROR_INVALID_EXTENSION"
    fi
    
    show_header "Template Preview: .$extension ($(get_language_name "$extension"))"
    
    local template
    template=$(get_template "$extension" "AUTHOR_NAME" "$(date +"$DEFAULT_DATE_FORMAT")" 2>/dev/null) || {
        error_exit "Failed to preview template"
    }
    
    # Replace placeholders with actual values
    template="${template//AUTHOR/$DEFAULT_AUTHOR}"
    template="${template//DATE/$(date +"$DEFAULT_DATE_FORMAT")}"
    
    echo "$template"
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

# Ask to open file in editor
ask_open_editor() {
    local filename="$1"
    local author="$2"
    
    read -t "$INPUT_TIMEOUT" -p "Open in editor? (y/n) " -n 1 choice
    echo
    
    case "$choice" in
        y|Y)
            if command_exists "$DEFAULT_EDITOR"; then
                log_info "Opening $filename in $DEFAULT_EDITOR..."
                "$DEFAULT_EDITOR" "$filename" || log_warn "Failed to open editor"
            else
                log_warn "Editor '$DEFAULT_EDITOR' not found"
            fi
            ;;
        *)
            ;;
    esac
}
