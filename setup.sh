#!/usr/bin/env bash
#
# Universal Bootstrap Setup Script
# ---------------------------------------------------------------
#   Clones dependencies, installs Nix + Devbox,
#   applies base Nix config (macOS or Linux),
#   imports keys, sets Git identities,
#   links configs, and prepares ~/code workspace.
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
red() { printf "\033[1;31m%s\033[0m\n" "$@"; }
die() {
  red "Error: $*"
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
# Ensure the repo lives in ~/.dotfiles
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
# Update any submodules (e.g. secrets repo)
# ---------------------------------------------------------------

if [ -f .gitmodules ]; then
  green "⬇️  Updating git submodules..."
  git submodule update --init --recursive
fi

# ---------------------------------------------------------------
# Install Nix + Devbox
# ---------------------------------------------------------------

green "⬇️  Installing Nix and Devbox..."
bash bootstrap/install_nix.sh
bash bootstrap/install_devbox.sh

# ---------------------------------------------------------------
# Apply OS‑specific Nix configuration
# ---------------------------------------------------------------

green "🧩  Applying base Nix configuration..."
bash bootstrap/apply_nix_config.sh || yellow "⚠️  Failed to apply Nix config (non‑fatal)"

# ---------------------------------------------------------------
# Import secret keys (optional)
# ---------------------------------------------------------------

bash bootstrap/import_keys.sh || yellow "⚠️  Skipped key import (secrets‑repo missing)"

# ---------------------------------------------------------------
# Configure Git identities
# ---------------------------------------------------------------

bash bootstrap/setup_git_identity.sh || yellow "⚠️  Git identity setup skipped"

# ---------------------------------------------------------------
# Link dotfiles and config files
# ---------------------------------------------------------------

bash bootstrap/link_configs.sh

# ---------------------------------------------------------------
# Prepare ~/code workspace
# ---------------------------------------------------------------

bash bootstrap/setup_code_dir.sh

# ---------------------------------------------------------------
# Finish
# ---------------------------------------------------------------

green "✅  Bootstrap complete!"
echo "• Repo directory : ${REPO_DIR}"
echo "• Code workspace : ${CODE_DIR}"
echo "• Base Nix config applied for: ${PLATFORM}"
echo "• Run: 'devbox shell' in any project to enter its environment."
