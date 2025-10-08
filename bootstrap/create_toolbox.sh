#!/usr/bin/env bash
set -euo pipefail
NAME="${TOOLBOX_NAME:-jack-dev}"

green() { printf "\033[1;32m%s\033[0m\n" "$@"; }
yellow() { printf "\033[1;33m%s\033[0m\n" "$@"; }

# prefer toolbox if available, fallback to distrobox
if command -v toolbox >/dev/null 2>&1; then
  TOOL_CMD="toolbox"
elif command -v distrobox >/dev/null 2>&1; then
  TOOL_CMD="distrobox"
else
  echo "❌ Neither toolbox nor distrobox found. Install one:"
  echo "   sudo dnf install -y toolbox   # Fedora"
  echo "   or"
  echo "   curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/install | sudo bash"
  exit 1
fi

if "$TOOL_CMD" list | grep -q "$NAME"; then
  yellow "📦 $NAME already exists, reusing it"
else
  green "🧱 Creating $TOOL_CMD container: $NAME"
  "$TOOL_CMD" create -y -n "$NAME"
fi

green "🚪 Entering container $NAME"
exec "$TOOL_CMD" enter "$NAME"
