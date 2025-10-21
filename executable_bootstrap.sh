#!/usr/bin/env bash
set -euo pipefail

echo "🚀 Bootstrapping dev environment..."

# Install Nix if not installed
if ! command -v nix >/dev/null 2>&1; then
  echo "📦 Installing Nix..."
  sh <(curl -L https://nixos.org/nix/install) --no-daemon
  . ~/.nix-profile/etc/profile.d/nix.sh
fi

# Apply configuration via Home Manager
if ! command -v home-manager >/dev/null 2>&1; then
  echo "📦 Installing Home Manager..."
  nix run github:nix-community/home-manager -- switch --flake ~/.config/nixpkgs#user
else
  home-manager switch --flake ~/.config/nixpkgs#user
fi

echo "✅ Environment ready!"
