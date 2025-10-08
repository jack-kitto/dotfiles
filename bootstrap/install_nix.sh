#!/usr/bin/env bash
set -e
echo "📦 Installing Nix (user mode)..."

if command -v nix >/dev/null 2>&1; then
  echo "✅ Nix already installed"
  exit 0
fi

# Upstream installer is simplest for macOS, Linux, and WSL
sh <(curl -L https://nixos.org/nix/install) --no-daemon

# activate immediately
. "${HOME}/.nix-profile/etc/profile.d/nix.sh"

echo "✅ Nix installed successfully ($(nix --version))"
