#!/usr/bin/env bash
set -e
echo "✨ Installing Devbox..."

if command -v devbox >/dev/null 2>&1; then
  echo "✅ Devbox already installed"
  exit 0
fi

curl -fsSL https://get.jetify.com/devbox | bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >>~/.bashrc
echo 'export PATH="$HOME/.local/bin:$PATH"' >>~/.zshrc
export PATH="$HOME/.local/bin:$PATH"

echo "✅ Devbox installed ($(devbox --version))"
