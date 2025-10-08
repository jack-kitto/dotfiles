#!/usr/bin/env bash
set -euo pipefail

NAME="${CONTAINER_NAME:-jack-dev}"
green() { printf "\033[1;32m%s\033[0m\n" "$@"; }

# Just create, don't enter
if ! distrobox list 2>/dev/null | grep -q "^${NAME}"; then
  green "🧱  Creating distrobox container: ${NAME}"
  distrobox create \
    --name "${NAME}" \
    --image fedora:latest \
    --home "${HOME}" \
    --additional-packages "git curl wget build-essential"
  echo "✅  Container ${NAME} created"
else
  echo "📦  Container ${NAME} already exists"
fi
