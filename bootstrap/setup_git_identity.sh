#!/usr/bin/env bash
set -e
echo "🪪 Setting up Git global identity..."

NAME="Jack Kitto"
EMAIL="jack.kitto@gmail.com"

if [ -f ~/.dotfiles/configs/git/gitconfig ]; then
  ln -sf ~/.dotfiles/configs/git/gitconfig ~/.gitconfig
  echo "🔗 Linked base gitconfig"
else
  cat >~/.gitconfig <<CONF
[user]
    name = ${NAME}
    email = ${EMAIL}
[commit]
    gpgsign = true
[gpg]
    program = gpg
[core]
    editor = nvim
CONF
  echo "📝 Created default gitconfig"
fi

# handle includeIf overrides if provided
if [ -d ~/.dotfiles/configs/git ]; then
  for file in ~/.dotfiles/configs/git/gitconfig-*; do
    key=$(basename "$file")
    [[ $key == *company* ]] || continue
    cp "$file" ~/
  done
fi
echo "✅ Git identity configured"
