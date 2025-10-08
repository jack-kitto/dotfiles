#!/usr/bin/env bash
#
# Simple, idempotent, single‑user Nix installer
# ---------------------------------------------

set -euo pipefail
green() { printf "\033[1;32m%s\033[0m\n" "$@"; }
yellow() { printf "\033[1;33m%s\033[0m\n" "$@"; }

green "📦 Checking Nix installation..."

if command -v nix >/dev/null 2>&1; then
  green "✅  Nix already installed ($(nix --version))"
  exit 0
fi

yellow "⬇️  Installing single‑user Nix (no daemon / no sudo)..."

curl -L https://nixos.org/nix/install | sh -s -- --no-daemon

# ---------------------------------------------------------------
# Activate profile immediately in this shell
# ---------------------------------------------------------------
PROFILE="$HOME/.nix-profile/etc/profile.d/nix.sh"
if [ -f "$PROFILE" ]; then
  # shellcheck disable=SC1091
  . "$PROFILE"
  green "✅  Activated single‑user Nix profile."
else
  yellow "⚠️  Nix installed; restart shell or source $PROFILE to enable it."
fi

nix --version || yellow "⚠️  Nix may not yet be in PATH (restart shell)."
