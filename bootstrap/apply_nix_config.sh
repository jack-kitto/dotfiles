#!/usr/bin/env bash
# Simplified Nix config applier for single‑user installs
set -euo pipefail

green() { printf "\033[1;32m%s\033[0m\n" "$@"; }
yellow() { printf "\033[1;33m%s\033[0m\n" "$@"; }

if ! command -v nix >/dev/null 2>&1; then
  yellow "⚠️ Nix not in PATH; skipping base config."
  exit 0
fi

# if /run/systemd or /nix/var/nix/profiles/default doesn't exist → assume single‑user
if [ ! -d /run/systemd ]; then
  yellow "🧩 Toolbox or single‑user environment detected — skipping daemon‑based config."
  exit 0
fi

OS="$(uname -s)"
REPO_DIR="${REPO_DIR:-$HOME/.dotfiles}"
FLAKE_PATH="${REPO_DIR}/nix"

case "$OS" in
Darwin)
  green "🍎 Applying nix‑darwin + Home‑Manager config"
  sudo darwin-rebuild switch --flake "${FLAKE_PATH}#jack-macos"
  ;;
Linux)
  green "🐧 Applying Home‑Manager configuration"
  nix run home-manager/master -- switch --flake "${FLAKE_PATH}#jack-linux"
  ;;
*)
  yellow "Unsupported OS; skipping Nix flake apply."
  ;;
esac
