#!/usr/bin/env bash
set -euo pipefail
echo "📦 Checking Nix installation..."

if command -v nix >/dev/null 2>&1; then
  echo "✅ Nix already installed ($(nix --version))"
  exit 0
fi

echo "⬇️ Installing Nix..."
if [[ "$(uname -s)" == "Linux" ]]; then
  sh <(curl -L https://nixos.org/nix/install) --daemon --no-channel-add
else
  sh <(curl -L https://nixos.org/nix/install) --no-daemon
fi

# shellcheck disable=SC1091
if [ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
elif [ -f "${HOME}/.nix-profile/etc/profile.d/nix.sh" ]; then
  . "${HOME}/.nix-profile/etc/profile.d/nix.sh"
fi

echo "✅ Nix installed successfully ($(nix --version))"
