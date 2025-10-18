#!/usr/bin/env bash
set -e

echo "🔧 Installing dotfiles..."

# Symlink configs into the home directory
ln -sf ~/.dotfiles/.zshrc ~/.zshrc
ln -sf ~/.dotfiles/.tmux.conf ~/.tmux.conf

# Neovim and others under .config
mkdir -p ~/.config
ln -sf ~/.dotfiles/.config/nvim ~/.config/nvim
ln -sf ~/.dotfiles/.config/zsh ~/.config/zsh
ln -sf ~/.dotfiles/.config/tmux ~/.config/tmux

echo "✅ Dotfiles setup complete!"
