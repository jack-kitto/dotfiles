#!/usr/bin/env bash
set -e
BREWFILE="${HOME}/.dotfiles/homebrew/Brewfile"

if [ ! -f "$BREWFILE" ]; then
  echo "⚠️  No Brewfile found; skipping package import"
  exit 0
fi

OS="$(uname -s)"
if [ "$OS" = "Darwin" ]; then
  echo "🍺 Installing Homebrew packages from Brewfile..."
  brew bundle --file="$BREWFILE"
else
  echo "🐧 Translating Brewfile to Linux packages..."
  while read -r line; do
    [[ "$line" =~ ^brew ]] || continue
    pkg=$(echo "$line" | awk '{print $2}' | tr -d '"')
    sudo dnf install -y "$pkg" 2>/dev/null || echo "⚠️  $pkg not found"
  done <"$BREWFILE"
fi

echo "✅ Package import complete"
