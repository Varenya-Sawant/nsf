#!/usr/bin/env bash
# =============================================================================
# uninstall.sh — Removes nsf from the system
#
# Usage:
#   ./uninstall.sh           Removes system-wide install
#   ./uninstall.sh --user    Removes user install
#
# This script removes exactly what install.sh put down — nothing more.
# It never touches ~/.config/nsf/nsf.conf or user templates — those belong
# to the user and should be preserved across reinstalls.
# =============================================================================

set -euo pipefail

# -----------------------------------------------------------------------------
# Colours
# -----------------------------------------------------------------------------
if [[ -t 1 ]]; then
    GREEN=$(tput setaf 2); YELLOW=$(tput setaf 3)
    BLUE=$(tput setaf 4); RESET=$(tput sgr0); BOLD=$(tput bold)
else
    GREEN="" YELLOW="" BLUE="" RESET="" BOLD=""
fi

info()  { echo "${GREEN}✓${RESET} $*"; }
step()  { echo "${BLUE}→${RESET} $*"; }
warn()  { echo "${YELLOW}⚠${RESET} $*"; }

# -----------------------------------------------------------------------------
# Determine mode and prefix
# -----------------------------------------------------------------------------
INSTALL_MODE="system"
if [[ "${1:-}" == "--user" ]]; then
    INSTALL_MODE="user"
fi

if [[ "${INSTALL_MODE}" == "user" ]]; then
    PREFIX="${HOME}/.local"
    SUDO=""
else
    PREFIX="/usr/local"
    SUDO="sudo"
fi

echo ""
echo "${BOLD}Uninstalling nsf${RESET}"
echo "  Mode:   ${INSTALL_MODE}"
echo "  Prefix: ${PREFIX}"
echo ""

# -----------------------------------------------------------------------------
# Remove core files
# -----------------------------------------------------------------------------
step "Removing bin/nsf"
${SUDO} rm -f "${PREFIX}/bin/nsf"
info "Removed ${PREFIX}/bin/nsf"

step "Removing lib and templates"
${SUDO} rm -rf "${PREFIX}/lib/nsf"
info "Removed ${PREFIX}/lib/nsf/"

# -----------------------------------------------------------------------------
# Remove shell completions
# -----------------------------------------------------------------------------
step "Removing shell completions"

rm -f /etc/bash_completion.d/nsf 2>/dev/null || true
rm -f "${HOME}/.local/share/bash-completion/completions/nsf" 2>/dev/null || true
rm -f "${HOME}/.zsh/completions/_nsf" 2>/dev/null || true
rm -f "${HOME}/.config/fish/completions/nsf.fish" 2>/dev/null || true
info "Shell completions removed"

# -----------------------------------------------------------------------------
# Preserve user config and templates — never delete these
# -----------------------------------------------------------------------------
warn "Preserving user config and templates:"
warn "  ~/.config/nsf/nsf.conf"
warn "  ~/.config/nsf/templates/"
warn "Delete these manually if you want a completely clean removal:"
warn "  rm -rf ~/.config/nsf"

echo ""
echo "${BOLD}nsf has been uninstalled.${RESET}"
echo ""
