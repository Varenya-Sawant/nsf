#!/usr/bin/env bash

#
# NSF Installation Script
# Installs NSF to the system
#

set -euo pipefail

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Installation paths
INSTALL_DIR="${INSTALL_DIR:-/usr/local/bin}"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NSF_MAIN="$REPO_DIR/bin/nsf"

# Check if running as root for system installation
check_permissions() {
    if [[ "$INSTALL_DIR" == "/usr/local/bin" ]] || [[ "$INSTALL_DIR" == "/usr/bin" ]]; then
        if [[ $EUID -ne 0 ]]; then
            echo -e "${YELLOW}[!]${NC} System installation requires sudo. Running with sudo..."
            exec sudo "$0" "$@"
        fi
    fi
}

# Function to print colored messages
print_info() {
    echo -e "${BLUE}[i]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

# Verify script exists
verify_script() {
    if [[ ! -f "$NSF_MAIN" ]]; then
        print_error "NSF main script not found at: $NSF_MAIN"
        exit 1
    fi
}

# Make scripts executable
make_executable() {
    print_info "Making scripts executable..."
    
    chmod +x "$NSF_MAIN" || {
        print_error "Failed to make $NSF_MAIN executable"
        exit 1
    }
    
    chmod +x "$REPO_DIR/lib"/*.sh 2>/dev/null || true
    
    print_success "Scripts made executable"
}

# Create installation directory
create_install_dir() {
    if [[ ! -d "$INSTALL_DIR" ]]; then
        print_info "Creating installation directory: $INSTALL_DIR"
        mkdir -p "$INSTALL_DIR" || {
            print_error "Failed to create directory: $INSTALL_DIR"
            exit 1
        }
    fi
}

# Install nsf
install_nsf() {
    print_info "Installing NSF to: $INSTALL_DIR"
    
    # Create symlink instead of copying
    if [[ -L "$INSTALL_DIR/nsf" ]]; then
        rm "$INSTALL_DIR/nsf"
    elif [[ -f "$INSTALL_DIR/nsf" ]]; then
        print_warning "Existing nsf installation found, backing up..."
        mv "$INSTALL_DIR/nsf" "$INSTALL_DIR/nsf.bak.$(date +%s)"
    fi
    
    ln -s "$NSF_MAIN" "$INSTALL_DIR/nsf" || {
        print_error "Failed to create symlink"
        exit 1
    }
    
    print_success "NSF installed successfully"
}

# Create config directory
setup_config() {
    local config_dir="$HOME/.config/nsf"
    
    print_info "Setting up configuration directory: $config_dir"
    
    mkdir -p "$config_dir" || {
        print_error "Failed to create config directory"
        return 1
    }
    
    if [[ ! -f "$config_dir/nsf.conf" ]]; then
        print_info "Creating default configuration..."
        cat > "$config_dir/nsf.conf" << 'EOF'
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
EOF
        print_success "Configuration created at: $config_dir/nsf.conf"
    else
        print_info "Configuration already exists"
    fi
}

# Verify installation
verify_installation() {
    print_info "Verifying installation..."
    
    if command -v nsf &>/dev/null; then
        local nsf_path
        nsf_path=$(command -v nsf)
        print_success "NSF installed at: $nsf_path"
        
        # Test command
        if nsf --version &>/dev/null; then
            print_success "Installation verified successfully"
            return 0
        else
            print_error "NSF command test failed"
            return 1
        fi
    else
        print_error "NSF not found in PATH"
        return 1
    fi
}

# Print usage information
print_usage() {
    cat << 'EOF'
Usage: ./install.sh [OPTIONS]

OPTIONS:
  --help              Show this help message
  --user              Install to ~/.local/bin (user installation)
  --system            Install to /usr/local/bin (default, requires sudo)
  --uninstall         Remove NSF installation

ENVIRONMENT VARIABLES:
  INSTALL_DIR         Custom installation directory

EXAMPLES:
  ./install.sh                    # Install to /usr/local/bin (system)
  ./install.sh --user             # Install to ~/.local/bin (user)
  INSTALL_DIR=~/bin ./install.sh  # Install to custom directory

EOF
}

# Handle command-line arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --help|-h)
                print_usage
                exit 0
                ;;
            --user)
                INSTALL_DIR="$HOME/.local/bin"
                mkdir -p "$INSTALL_DIR"
                shift
                ;;
            --system)
                INSTALL_DIR="/usr/local/bin"
                shift
                ;;
            --uninstall)
                uninstall_nsf
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                print_usage
                exit 1
                ;;
        esac
    done
}

# Uninstall function
uninstall_nsf() {
    print_info "Uninstalling NSF..."
    
    if [[ -L "$INSTALL_DIR/nsf" ]] || [[ -f "$INSTALL_DIR/nsf" ]]; then
        rm "$INSTALL_DIR/nsf" || {
            print_error "Failed to remove NSF from $INSTALL_DIR/nsf"
            exit 1
        }
        print_success "NSF uninstalled successfully"
    else
        print_warning "NSF not found at: $INSTALL_DIR/nsf"
    fi
}

# Main installation flow
main() {
    echo
    echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║  NSF - New Script File Creator         ║${NC}"
    echo -e "${BLUE}║  Installation Script                   ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
    echo
    
    parse_args "$@"
    
    print_info "Installation directory: $INSTALL_DIR"
    
    verify_script
    make_executable
    create_install_dir
    install_nsf
    setup_config
    
    if verify_installation; then
        echo
        print_success "NSF installation completed successfully!"
        echo
        echo -e "${GREEN}Next steps:${NC}"
        echo "  - Test: nsf --help"
        echo "  - Create a script: nsf example.sh"
        echo "  - Edit config: ~/.config/nsf/nsf.conf"
        echo
    else
        print_error "Installation verification failed"
        exit 1
    fi
}

# Run main with elevated permissions if needed
check_permissions
main "$@"
