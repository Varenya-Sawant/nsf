#!/usr/bin/env bash

#
# nsf Uninstallation Script
# Removes nsf from your system
#

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

# Functions
log_info() { echo -e "${BLUE}ℹ${RESET} $*"; }
log_success() { echo -e "${GREEN}✓${RESET} $*"; }
log_warning() { echo -e "${YELLOW}⚠${RESET} $*"; }
log_error() { echo -e "${RED}✗${RESET} $*" >&2; }

UNINSTALL_DIR="${1:-.}"

log_info "Uninstalling nsf from: $UNINSTALL_DIR"

# Confirmation
read -rp "Are you sure? (y/N): " confirm
[[ "$confirm" != "y" ]] && log_warning "Uninstall cancelled" && exit 0

# Remove symlink
if [[ -L "/usr/local/bin/nsf" ]]; then
    if rm "/usr/local/bin/nsf"; then
        log_success "Removed /usr/local/bin/nsf symlink"
    else
        log_warning "Could not remove symlink (may require sudo)"
    fi
fi

# Remove directories
for dir in bin lib templates config; do
    if [[ -d "$UNINSTALL_DIR/$dir" ]]; then
        if rm -rf "$UNINSTALL_DIR/$dir"; then
            log_success "Removed $dir"
        else
            log_error "Failed to remove $dir"
        fi
    fi
done

log_success "Uninstallation complete!"
