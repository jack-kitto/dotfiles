#!/usr/bin/env bash
#
# 🌱 Universal Bootstrap Setup Script - Distrobox Edition
# ---------------------------------------------------------------
#   Always creates a distrobox container and runs setup inside it
# ---------------------------------------------------------------

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONTAINER_NAME="jack-dev"

green() { printf "\033[1;32m%s\033[0m\n" "$@"; }
yellow() { printf "\033[1;33m%s\033[0m\n" "$@"; }
red() { printf "\033[1;31m%s\033[0m\n" "$@"; }

# Check if we're already inside the container
if [ -n "${DISTROBOX_ENTERED:-}" ]; then
  green "🚀  Running setup inside distrobox container..."
  exec "${REPO_DIR}/bootstrap/setup_inside_container.sh"
fi

# We're on the host - create container and run setup inside it
green "🧱  Setting up distrobox container: ${CONTAINER_NAME}"

# Install distrobox if not present
if ! command -v distrobox >/dev/null 2>&1; then
  yellow "⬇️  Installing distrobox..."
  curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/install | sudo bash
fi

# Create container if it doesn't exist
if ! distrobox list 2>/dev/null | grep -q "^${CONTAINER_NAME}"; then
  green "🏗️   Creating new distrobox container..."
  distrobox create \
    --name "${CONTAINER_NAME}" \
    --image fedora:latest \
    --home "${HOME}" \
    --volume "${REPO_DIR}:${REPO_DIR}:rw" \
    --additional-packages "git curl wget"
fi

green "🚪  Entering container and running setup..."
distrobox enter "${CONTAINER_NAME}" -- bash "${REPO_DIR}/setup.sh"

green "✅  Setup complete! Enter your dev environment with:"
echo "    distrobox enter ${CONTAINER_NAME}"
