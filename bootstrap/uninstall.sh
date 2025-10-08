#!/usr/bin/env bash
#
# Remove Nix, Devbox, and linked configs (reversible baseline)
# ------------------------------------------------------------

set -euo pipefail
green() { printf "\033[1;32m%s\033[0m\n" "$@"; }
yellow() { printf "\033[1;33m%s\033[0m\n" "$@"; }
red() { printf "\033[1;31m%s\033[0m\n" "$@"; }

read -rp "⚠️  This will remove Nix, Devbox and related data. Continue? (y/N): " ok
[[ "$ok" =~ ^[Yy]$ ]] || {
  yellow "Aborted."
  exit 0
}

green "🧹 Removing Nix profiles and store..."
if command -v home-manager &>/dev/null; then
  home-manager expire-generations 0 --delete || true
fi
sudo rm -rf /nix /etc/nix || true
rm -rf ~/.nix* ~/.cache/nix ~/.local/state/nix ~/.config/nix || true

green "💨 Removing Devbox..."
sudo rm -f /usr/local/bin/devbox ~/.local/bin/devbox 2>/dev/null || true
rm -rf ~/.devbox ~/.cache/devbox ~/.config/devbox || true

green "🔗 Reverting config links..."
find -H ~ -maxdepth 1 -type l -lname "$HOME/.dotfiles/*" -exec rm {} \; || true

green "✅ Uninstall complete. Reboot to fully unload Nix daemons (macOS)."
