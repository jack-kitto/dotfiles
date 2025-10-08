#!/usr/bin/env bash
#
# Setup script that runs inside the distrobox container
# ---------------------------------------------------------------

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CODE_DIR="${HOME}/code"

green() { printf "\033[1;32m%s\033[0m\n" "$@"; }
yellow() { printf "\033[1;33m%s\033[0m\n" "$@"; }

green "🐧  Running inside distrobox container..."

# Ensure we're in the right directory
cd "${REPO_DIR}"

# Update submodules
if [ -f .gitmodules ]; then
  green "⬇️  Updating git submodules..."
  git submodule update --init --recursive 2>/dev/null || true
fi

# Install Nix in single-user mode
green "📦  Installing Nix (single-user mode)..."
bash bootstrap/install_nix.sh

# Source Nix profile for this session
if [ -f "${HOME}/.nix-profile/etc/profile.d/nix.sh" ]; then
  # shellcheck disable=SC1091
  source "${HOME}/.nix-profile/etc/profile.d/nix.sh"
fi

# Install Devbox
green "⬇️  Installing Devbox..."
bash bootstrap/install_devbox.sh

# Apply Nix configuration (Home Manager for Linux)
green "🧩  Applying Nix configuration..."
if command -v nix >/dev/null 2>&1; then
  nix run home-manager/master -- switch --flake "${REPO_DIR}/nix#jack-linux" 2>/dev/null || {
    yellow "⚠️  Home Manager config failed, continuing..."
  }
fi

# Import keys and setup git
green "🔐  Setting up keys and git identity..."
bash bootstrap/import_keys.sh || true
bash bootstrap/setup_git_identity.sh

# Link configs
green "🔗  Linking configurations..."
bash bootstrap/link_configs.sh

# Setup code directory
green "📁  Setting up code workspace..."
bash bootstrap/setup_code_dir.sh

green "✅  Container setup complete!"
echo "• Nix installed in single-user mode"
echo "• All configs linked and ready"
echo "• Code workspace: ${CODE_DIR}"
echo ""
echo "Start coding with:"
echo "  cd ~/code"
echo "  git clone <your-repo>"
echo "  cd <your-repo>"
echo "  devbox init"
echo "  devbox shell"
