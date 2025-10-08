#!/usr/bin/env bash
set -euo pipefail
NAME="${TOOLBOX_NAME:-jack-dev}"

green() { printf "\033[1;32m%s\033[0m\n" "$@"; }
yellow() { printf "\033[1;33m%s\033[0m\n" "$@"; }
red() { printf "\033[1;31m%s\033[0m\n" "$@"; }

# Pick whichever is installed
if command -v toolbox >/dev/null 2>&1; then
  TOOL_CMD="toolbox"
elif command -v distrobox >/dev/null 2>&1; then
  TOOL_CMD="distrobox"
else
  red "❌ Neither toolbox nor distrobox is installed."
  echo "Install one:"
  echo "  sudo dnf install -y toolbox"
  echo "  or"
  echo "  curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/install | sudo bash"
  exit 1
fi

# Detect container existence
if "$TOOL_CMD" list 2>/dev/null | grep -q "$NAME"; then
  yellow "📦  $NAME already exists — reusing"
else
  green "🧱  Creating $TOOL_CMD container: $NAME"

  if [ "$TOOL_CMD" = "toolbox" ]; then
    # Older fedora toolbox (no -n, no -y)
    "$TOOL_CMD" create --container "$NAME"
  else
    # Distrobox syntax is consistent
    "$TOOL_CMD" create -n "$NAME"
  fi
fi

green "🚪 Entering container $NAME"
if [ "$TOOL_CMD" = "toolbox" ]; then
  "$TOOL_CMD" enter --container "$NAME"
else
  "$TOOL_CMD" enter -n "$NAME"
fi
