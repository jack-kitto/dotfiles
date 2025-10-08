#!/usr/bin/env bash
set -euo pipefail
NAME="${TOOLBOX_NAME:-jack-dev}"

green() { printf "\033[1;32m%s\033[0m\n" "$@"; }
yellow() { printf "\033[1;33m%s\033[0m\n" "$@"; }
red() { printf "\033[1;31m%s\033[0m\n" "$@"; }

# Pick toolbox or distrobox
if command -v toolbox >/dev/null 2>&1; then
  TOOL_CMD="toolbox"
elif command -v distrobox >/dev/null 2>&1; then
  TOOL_CMD="distrobox"
else
  red "❌ Neither toolbox nor distrobox found."
  echo "Install one of them:"
  echo "  sudo dnf install -y toolbox"
  echo "  or"
  echo "  curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/install | sudo bash"
  exit 1
fi

# Check our toolbox/container name flag style
supports_short_flag=false
if "$TOOL_CMD" create --help 2>&1 | grep -q "\-n"; then
  supports_short_flag=true
fi

# See if it exists already
if "$TOOL_CMD" list 2>/dev/null | grep -q "$NAME"; then
  yellow "📦  $NAME already exists — reusing"
else
  green "🧱  Creating $TOOL_CMD container: $NAME"
  if [ "$TOOL_CMD" = "toolbox" ]; then
    if $supports_short_flag; then
      "$TOOL_CMD" create -y -n "$NAME"
    else
      "$TOOL_CMD" create --y --container "$NAME"
    fi
  else
    # distrobox syntax
    "$TOOL_CMD" create -n "$NAME" || "$TOOL_CMD" create --name "$NAME"
  fi
fi

green "🚪 Entering container $NAME"
if [ "$TOOL_CMD" = "toolbox" ]; then
  "$TOOL_CMD" enter "$NAME"
else
  "$TOOL_CMD" enter "$NAME"
fi
