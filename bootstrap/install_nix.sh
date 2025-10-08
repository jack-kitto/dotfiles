#!/usr/bin/env bash
#
# Safe / Idempotent Nix installer
# - Detects existing installs
# - Falls back to single-user if inside container or SELinux=enforcing
# ---------------------------------------------------------------

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
# Detect containerization or SELinux
# ---------------------------------------------------------------

is_container() {
  grep -qE 'container=|distrobox|podman|docker' /proc/1/environ 2>/dev/null ||
    grep -qiE 'distrobox|toolbox' /etc/os-release 2>/dev/null ||
    grep -E -q 'docker|podman' /proc/1/cgroup 2>/dev/null
}

is_selinux_enforcing() {
  sestatus 2>/dev/null | grep -qi 'enforcing'
}

if [[ "$(uname -s)" == "Linux" ]]; then
  if is_container || is_selinux_enforcing; then
    yellow "🐧 Detected SELinux or container — using single‑user Nix install."
    curl -L https://nixos.org/nix/install | sh -s -- --no-daemon
  else
    green "⬇️ Installing Nix (multi‑user daemon)..."
    sh <(curl -L https://nixos.org/nix/install) --daemon --no-channel-add
  fi
else
  green "🍎 Installing Nix (macOS no‑daemon)..."
  sh <(curl -L https://nixos.org/nix/install) --no-daemon
fi

# ---------------------------------------------------------------
# Activate profile immediately
# ---------------------------------------------------------------
if [ -f "${HOME}/.nix-profile/etc/profile.d/nix.sh" ]; then
  # shellcheck disable=SC1091
  . "${HOME}/.nix-profile/etc/profile.d/nix.sh"
  green "✅ Activated single‑user Nix profile."
elif [ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
  # shellcheck disable=SC1091
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  green "✅ Activated multi‑user Nix profile."
fi

nix --version || yellow "⚠️  Nix installed but not yet in PATH (restart shell)."
