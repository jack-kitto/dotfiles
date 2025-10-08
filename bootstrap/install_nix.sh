#!/usr/bin/env bash
set -euo pipefail

green() { printf "\033[1;32m%s\033[0m\n" "$@"; }
yellow() { printf "\033[1;33m%s\033[0m\n" "$@"; }

green "📦  Checking Nix installation..."

if command -v nix >/dev/null 2>&1; then
  green "✅  Nix already installed ($(nix --version))"
  exit 0
fi

yellow "⬇️  Installing Nix (single-user, no daemon)..."

# Force single-user installation
export NIX_INSTALLER_NO_MODIFY_PROFILE=1
curl -L https://nixos.org/nix/install | sh -s -- --no-daemon

# Add to current shell
PROFILE="$HOME/.nix-profile/etc/profile.d/nix.sh"
if [ -f "$PROFILE" ]; then
  # shellcheck disable=SC1091
  source "$PROFILE"
  green "✅  Nix installed and activated"
fi

# Add to shell profiles
for rc in ~/.bashrc ~/.zshrc ~/.profile; do
  if [ -f "$rc" ]; then
    grep -q 'nix-profile/etc/profile.d/nix.sh' "$rc" 2>/dev/null || {
      echo "# Nix" >>"$rc"
      echo '. ~/.nix-profile/etc/profile.d/nix.sh' >>"$rc"
    }
  fi
done

echo "Nix version: $(nix --version)"
