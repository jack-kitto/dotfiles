#!/usr/bin/env bash
#
# 🌱 Universal Bootstrap Setup Script
# ---------------------------------------------------------------
#   Clones dependencies, installs Nix + Devbox,
#   applies base Nix config (macOS or Linux),
#   imports keys, sets Git identities,
#   links configs, and prepares ~/code workspace.
#
#   Compatible with SELinux (auto‑Toolbox/Distrobox)
# ---------------------------------------------------------------

set -euo pipefail

# Dynamically determine the repo root
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
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
# Detect operating system / environment
# ---------------------------------------------------------------

OS="$(uname -s)"
PLATFORM="unknown"

case "$OS" in
Darwin)
  PLATFORM="macos"
  ;;
Linux)
  if command -v getenforce >/dev/null 2>&1 &&
    [[ "$(getenforce 2>/dev/null)" == "Enforcing" ]] &&
    [ -z "${IN_TOOLBOX:-}" ] && [ -z "${DISTROBOX_ENTERED:-}" ]; then
    PLATFORM="linux-selinux"
  else
    PLATFORM="linux"
  fi
  ;;
*)
  die "Unsupported OS: ${OS}"
  ;;
esac

green "🧭  Detected platform: ${PLATFORM}"

# ---------------------------------------------------------------
# SELinux → Toolbox/Distrobox hand‑off
# ---------------------------------------------------------------

if [ "$PLATFORM" = "linux-selinux" ]; then
  yellow "🧱  SELinux Enforcing detected — running inside Toolbox/Distrobox"

  bash "${REPO_DIR}/bootstrap/create_toolbox.sh"

  # if create_toolbox.sh returns at all, it failed
  die "Failed to enter Toolbox/Distrobox environment. Please run:
       ${REPO_DIR}/bootstrap/create_toolbox.sh"
fi

# ---------------------------------------------------------------
# Ensure the repo lives in ~/.dotfiles (optional)
# ---------------------------------------------------------------

if [ "$REPO_DIR" != "${HOME}/.dotfiles" ]; then
  if [ ! -d "${HOME}/.dotfiles" ]; then
    green "📦  Copying dotfiles into ~/.dotfiles"
    mkdir -p "${HOME}"
    cp -R "${REPO_DIR}" "${HOME}/.dotfiles"
  fi
  cd "${HOME}/.dotfiles"
  export REPO_DIR="${HOME}/.dotfiles"
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
echo "• Re‑enter Toolbox later with: toolbox enter jack-dev   # or distrobox enter jack-dev"
