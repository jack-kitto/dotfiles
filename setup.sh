#!/usr/bin/env bash
#
# Universal Bootstrap Setup Script
# ---------------------------------------------------------------
# Clones dependencies, installs Nix + Devbox, links configs,
# imports keys, sets Git identities, installs packages (brew/DNF),
# and prepares the ~/code workspace.
#
# Usage:
#   bash setup.sh
# ---------------------------------------------------------------

set -euo pipefail

REPO_DIR="${HOME}/.dotfiles"
CODE_DIR="${HOME}/code"

# ---------------------------------------------------------------
# Helper functions
# ---------------------------------------------------------------

green() { printf "\033[1;32m%s\033[0m\n" "$@"; }
yellow() { printf "\033[1;33m%s\033[0m\n" "$@"; }
die() {
  printf "\033[1;31mError:\033[0m %s\n" "$@" >&2
  exit 1
}

# ---------------------------------------------------------------
# Detect operating system
# ---------------------------------------------------------------

OS="$(uname -s)"
case "${OS}" in
Darwin) PLATFORM="macos" ;;
Linux) PLATFORM="linux" ;;
*) die "Unsupported OS: ${OS}" ;;
esac

green "🧭  Detected platform: ${PLATFORM}"

# ---------------------------------------------------------------
# Clone repo into ~/.dotfiles if needed
# ---------------------------------------------------------------

if [ "$(pwd)" != "${REPO_DIR}" ]; then
  if [ ! -d "${REPO_DIR}" ]; then
    green "📦  Copying dotfiles into ${REPO_DIR}"
    mkdir -p "$(dirname "${REPO_DIR}")"
    cp -R . "${REPO_DIR}"
  fi
  cd "${REPO_DIR}"
fi

# ---------------------------------------------------------------
# Update submodules (e.g. secrets‑repo)
# ---------------------------------------------------------------

if [ -f .gitmodules ]; then
  green "⬇️  Updating git submodules..."
  git submodule update --init --recursive
fi

# ---------------------------------------------------------------
# Run platform‑specific prerequisites
# ---------------------------------------------------------------

if [ "${PLATFORM}" = "macos" ]; then
  green "🍎  Setting up macOS..."

  # Homebrew
  if ! command -v brew &>/dev/null; then
    yellow "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  # Install common packages from Brewfile
  bash bootstrap/import_brewfile.sh || echo "⚠️  Homebrew import skipped or failed"
else
  green "🐧  Setting up Linux environment..."

  # Optional: create toolbox/distrobox (if script present)
  if [ -x "${REPO_DIR}/toolboxes/create-dev.sh" ]; then
    yellow "Creating Dev Toolbox (if not present)..."
    bash "${REPO_DIR}/toolboxes/create-dev.sh" || true
  fi

  # Import Brewfile with DNF bridge
  bash bootstrap/import_brewfile.sh || echo "⚠️  Package import skipped"
fi

# ---------------------------------------------------------------
# Install Nix + Devbox
# ---------------------------------------------------------------

bash bootstrap/install_nix.sh
bash bootstrap/install_devbox.sh

# ---------------------------------------------------------------
# Import secret keys (SSH + GPG) & GitHub auth
# ---------------------------------------------------------------

bash bootstrap/import_keys.sh || echo "⚠️  Key import skipped (secrets‑repo missing)"

# ---------------------------------------------------------------
# Configure Git identities
# ---------------------------------------------------------------

bash bootstrap/setup_git_identity.sh || echo "⚠️  Git identity setup skipped"

# ---------------------------------------------------------------
# Link configuration files
# ---------------------------------------------------------------

bash bootstrap/link_configs.sh

# ---------------------------------------------------------------
# Setup base code directory
# ---------------------------------------------------------------

bash bootstrap/setup_code_dir.sh

# ---------------------------------------------------------------
# Finish up
# ---------------------------------------------------------------

green "✅  Bootstrap complete!"
echo "•  Repo directory : ${REPO_DIR}"
echo "•  Code workspace  : ${CODE_DIR}"
echo "•  Run 'devbox shell' in any project to start a reproducible session."
