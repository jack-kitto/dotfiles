#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="${REPO_DIR:-$HOME/.dotfiles}"
FLAKE_PATH="${REPO_DIR}/nix"

green() { printf "\033[1;32m%s\033[0m\n" "$@"; }
yellow() { printf "\033[1;33m%s\033[0m\n" "$@"; }
red() { printf "\033[1;31m%s\033[0m\n" "$@"; }

OS="$(uname -s)"
case "$OS" in
Darwin) PLATFORM="macos" ;;
Linux) PLATFORM="linux" ;;
*)
  red "Unsupported OS: ${OS}"
  exit 1
  ;;
esac

green "🧭 Detected platform: ${PLATFORM}"

# Ensure nix
if ! command -v nix >/dev/null 2>&1; then
  yellow "Installing Nix..."
  sh <(curl -L https://nixos.org/nix/install) --daemon --no-channel-add
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

if [ "${PLATFORM}" = "macos" ]; then
  green "🍎  Applying nix-darwin + Home‑Manager config"
  sudo darwin-rebuild switch --flake "${FLAKE_PATH}#jack-macos" ||
    (yellow "Installing nix‑darwin..." &&
      nix build "${FLAKE_PATH}#darwinConfigurations.jack-macos.system" &&
      ./result/sw/bin/darwin-rebuild switch --flake "${FLAKE_PATH}#jack-macos")
else
  green "🐧  Applying Home‑Manager configuration"
  nix run home-manager/master -- switch --flake "${FLAKE_PATH}#jack-linux"
fi

green "✅ Nix base environment applied."
