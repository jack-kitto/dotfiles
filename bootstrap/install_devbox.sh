#!/usr/bin/env bash
set -euo pipefail
echo "✨ Checking Devbox installation..."

if command -v devbox >/dev/null 2>&1; then
  echo "✅ Devbox already installed ($(devbox --version))"
  exit 0
fi

echo "⬇️ Installing Devbox..."
curl -fsSL https://get.jetify.com/devbox | bash
for rc in ~/.bashrc ~/.zshrc; do
  grep -q 'PATH=.*\.local/bin' "$rc" 2>/dev/null ||
    echo 'export PATH="$HOME/.local/bin:$PATH"' >>"$rc"
done
export PATH="$HOME/.local/bin:$PATH"

echo "✅ Devbox installed ($(devbox --version))"
