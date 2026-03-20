#!/usr/bin/env bash
# =============================================================================
# install.sh — Installer for nsf
#
# Usage:
#   ./install.sh           System-wide install (requires sudo, installs to /usr/local)
#   ./install.sh --user    User install (no sudo, installs to ~/.local)
#
# What it installs:
#   - bin/nsf              -> PREFIX/bin/nsf
#   - lib/                 -> PREFIX/lib/nsf/lib/
#   - templates/           -> PREFIX/lib/nsf/templates/
#   - completions/         -> appropriate shell completion directories
#   - config/nsf.conf      -> ~/.config/nsf/nsf.conf (if not already present)
# =============================================================================

set -euo pipefail

# -----------------------------------------------------------------------------
# Preflight: Bash version check
# We check this before anything else because the rest of install.sh uses
# features that require Bash 4+ (associative arrays, ,, lowercasing, etc.)
# -----------------------------------------------------------------------------
if [[ "${BASH_VERSINFO[0]}" -lt 4 ]]; then
    echo "✗ nsf requires Bash 4.0 or higher to install." >&2
    echo "  Your version: ${BASH_VERSION}" >&2
    echo "" >&2
    echo "  On macOS, install a newer bash:" >&2
    echo "    brew install bash" >&2
    echo "  Then run this installer with the new bash:" >&2
    echo "    /opt/homebrew/bin/bash install.sh" >&2
    exit 1
fi

# -----------------------------------------------------------------------------
# Colours for installer output
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
error() { echo "✗ $*" >&2; }

# -----------------------------------------------------------------------------
# Determine install prefix (system vs user)
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
    # Check if we need sudo for system install
    if [[ ! -w "${PREFIX}" ]]; then
        SUDO="sudo"
    else
        SUDO=""
    fi
fi

# Resolve the directory containing this install.sh script
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

NSF_INSTALL_DIR="${PREFIX}/lib/nsf"
NSF_BIN_DIR="${PREFIX}/bin"
NSF_CONFIG_DIR="${HOME}/.config/nsf"

echo ""
echo "${BOLD}Installing nsf${RESET}"
echo "  Mode:   ${INSTALL_MODE}"
echo "  Prefix: ${PREFIX}"
echo ""

# -----------------------------------------------------------------------------
# Create directories
# -----------------------------------------------------------------------------
step "Creating directories"
${SUDO} mkdir -p "${NSF_BIN_DIR}"
${SUDO} mkdir -p "${NSF_INSTALL_DIR}"
mkdir -p "${NSF_CONFIG_DIR}"
mkdir -p "${NSF_CONFIG_DIR}/templates"

# -----------------------------------------------------------------------------
# Copy core files
# -----------------------------------------------------------------------------
step "Installing lib/"
${SUDO} cp -r "${REPO_DIR}/lib"       "${NSF_INSTALL_DIR}/"

step "Installing templates/"
${SUDO} cp -r "${REPO_DIR}/templates" "${NSF_INSTALL_DIR}/"

step "Installing bin/nsf"
${SUDO} cp "${REPO_DIR}/bin/nsf" "${NSF_BIN_DIR}/nsf"
${SUDO} chmod +x "${NSF_BIN_DIR}/nsf"

# -----------------------------------------------------------------------------
# Install user config (only if not already present — never overwrite)
# -----------------------------------------------------------------------------
if [[ ! -f "${NSF_CONFIG_DIR}/nsf.conf" ]]; then
    step "Installing default config to ${NSF_CONFIG_DIR}/nsf.conf"
    cp "${REPO_DIR}/config/nsf.conf" "${NSF_CONFIG_DIR}/nsf.conf"
else
    warn "Config already exists at ${NSF_CONFIG_DIR}/nsf.conf — leaving untouched"
fi

# -----------------------------------------------------------------------------
# Install shell completions
# Detect which shells are available and install to the right location.
# We never fail if a shell isn't present — completions are optional.
# -----------------------------------------------------------------------------
step "Installing shell completions"

# Bash
if command -v bash > /dev/null 2>&1; then
    if [[ -d /etc/bash_completion.d ]] && [[ "${INSTALL_MODE}" == "system" ]]; then
        ${SUDO} cp "${REPO_DIR}/completions/nsf.bash" /etc/bash_completion.d/nsf
        info "Bash completion installed to /etc/bash_completion.d/nsf"
    elif [[ -d "${HOME}/.local/share/bash-completion/completions" ]]; then
        cp "${REPO_DIR}/completions/nsf.bash" \
            "${HOME}/.local/share/bash-completion/completions/nsf"
        info "Bash completion installed (user)"
    else
        mkdir -p "${HOME}/.local/share/bash-completion/completions"
        cp "${REPO_DIR}/completions/nsf.bash" \
            "${HOME}/.local/share/bash-completion/completions/nsf"
        info "Bash completion installed (user, directory created)"
    fi
fi

# Zsh
if command -v zsh > /dev/null 2>&1; then
    local_zsh_dir="${HOME}/.zsh/completions"
    mkdir -p "${local_zsh_dir}"
    cp "${REPO_DIR}/completions/nsf.zsh" "${local_zsh_dir}/_nsf"
    info "Zsh completion installed to ${local_zsh_dir}/_nsf"
    warn "Add to ~/.zshrc if not already present:"
    warn "  fpath=(~/.zsh/completions \$fpath)"
    warn "  autoload -Uz compinit && compinit"
fi

# Fish
if command -v fish > /dev/null 2>&1; then
    fish_dir="${HOME}/.config/fish/completions"
    mkdir -p "${fish_dir}"
    cp "${REPO_DIR}/completions/_nsf.fish" "${fish_dir}/nsf.fish"
    info "Fish completion installed to ${fish_dir}/nsf.fish"
fi

# -----------------------------------------------------------------------------
# Verify the installation works
# -----------------------------------------------------------------------------
step "Verifying installation"

# Update PATH for this session so we can call nsf immediately
export PATH="${NSF_BIN_DIR}:${PATH}"

if bash "${NSF_BIN_DIR}/nsf" --version > /dev/null 2>&1; then
    info "nsf $(bash "${NSF_BIN_DIR}/nsf" --version) installed successfully"
else
    error "Installation verification failed — nsf --version returned non-zero"
    exit 1
fi

# -----------------------------------------------------------------------------
# Post-install message
# -----------------------------------------------------------------------------
echo ""
echo "${BOLD}Done!${RESET}"
echo ""

if [[ "${INSTALL_MODE}" == "user" ]]; then
    echo "  Make sure ${PREFIX}/bin is in your PATH:"
    echo "    export PATH=\"${PREFIX}/bin:\$PATH\""
    echo "  Add this line to your ~/.bashrc or ~/.zshrc to make it permanent."
    echo ""
fi

echo "  Quick start:"
echo "    nsf --help"
echo "    nsf myscript.py"
echo "    nsf --dry-run api.go"
echo ""
echo "  Config: ${NSF_CONFIG_DIR}/nsf.conf"
echo "  User templates: ${NSF_CONFIG_DIR}/templates/"
echo ""
