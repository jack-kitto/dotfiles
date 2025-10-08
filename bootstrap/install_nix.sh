#!/usr/bin/env bash
#
# Safe, container‑aware Nix installer
# ----------------------------------
set -euo pipefail
green() { printf "\033[1;32m%s\033[0m\n" "$@"; }
yellow() { printf "\033[1;33m%s\033[0m\n" "$@"; }
red() { printf "\033[1;31m%s\033[0m\n" "$@"; }

green "📦 Checking Nix installation..."

if command -v nix >/dev/null 2>&1; then
  green "✅ Nix already installed ($(nix --version))"
  exit 0
fi

# ---------------------------------------------------------------
# Environment detection helpers
# ---------------------------------------------------------------
is_container() {
  # Toolbox / Distrobox
  [[ -n "${IN_TOOLBOX:-}" ]] || [[ -n "${DISTROBOX_ENTERED:-}" ]] && return 0
  # Generic container detection
  grep -qE 'container=' /proc/1/environ 2>/dev/null && return 0
  grep -qiE 'toolbox|distrobox|docker|podman' /etc/os-release 2>/dev/null && return 0
  grep -E -q 'docker|podman' /proc/1/cgroup 2>/dev/null && return 0
  return 1
}

# ---------------------------------------------------------------
# Install strategy
# ---------------------------------------------------------------
OS="$(uname -s)"

if [[ "$OS" == "Linux" ]]; then
  if is_container; then
    yellow "🐧 Detected Toolbox/Distrobox or other container — using single‑user Nix install."
    curl -L https://nixos.org/nix/install | sh -s -- --no-daemon
  elif command -v getenforce >/dev/null 2>&1 && [[ "$(getenforce)" == "Enforcing" ]]; then
    yellow "🐧 SELinux enforcing detected — using single‑user Nix install."
    curl -L https://nixos.org/nix/install | sh -s -- --no-daemon
  else
    green "⬇️  Installing multi‑user Nix daemon..."
    sh <(curl -L https://nixos.org/nix/install) --daemon --no-channel-add
  fi
else
  green "🍎 Installing Nix (macOS no‑daemon)..."
  sh <(curl -L https://nixos.org/nix/install) --no-daemon
fi

# ---------------------------------------------------------------
# Activate in‑shell
# ---------------------------------------------------------------
if [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
  # shellcheck disable=SC1091
  . "$HOME/.nix-profile/etc/profile.d/nix.sh"
  green "✅ Activated single‑user Nix profile."
elif [ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
  # shellcheck disable=SC1091
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  green "✅ Activated multi‑user Nix profile."
else
  yellow "⚠️  Nix install complete but profile not yet loaded (restart shell)."
fi

nix --version || yellow "⚠️  Nix installed but not yet on PATH."
