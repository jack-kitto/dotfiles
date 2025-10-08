#!/usr/bin/env bash
set -e
echo "🔐 Importing SSH and GPG keys (if present)..."

# SSH
mkdir -p ~/.ssh
chmod 700 ~/.ssh
if [ -d ~/.dotfiles/secrets-repo/ssh ]; then
  cp -f ~/.dotfiles/secrets-repo/ssh/id_* ~/.ssh/ 2>/dev/null || true
  chmod 600 ~/.ssh/id_* 2>/dev/null || true
  echo "✅ SSH keys imported"
fi

# GPG
if [ -f ~/.dotfiles/secrets-repo/gpg/private.gpg ]; then
  gpg --batch --yes --import ~/.dotfiles/secrets-repo/gpg/private.gpg
  echo "✅ GPG keys imported"
fi

# GitHub CLI tokens
if [ -f ~/.dotfiles/secrets-repo/gh/hosts.yml ]; then
  mkdir -p ~/.config/gh
  cp -f ~/.dotfiles/secrets-repo/gh/hosts.yml ~/.config/gh/hosts.yml
  echo "✅ GitHub auth loaded"
fi
