#!/usr/bin/env bash
# =============================================================================
# .bashrc - Bash Configuration File
# =============================================================================
# A clean, organized, and maintainable bash configuration
# Converted from .zshrc (2025-09-11)
# =============================================================================

# =============================================================================
# PERFORMANCE & COMPATIBILITY
# =============================================================================

# Stop here if not an interactive shell
[[ $- != *i* ]] && return

# Better history handling
shopt -s histappend # Append to history instead of overwrite
HISTCONTROL=ignoredups:erasedups
HISTSIZE=5000
HISTFILESIZE=10000

# Share command history across terminals
PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# Case-insensitive globbing
shopt -s nocaseglob

# =============================================================================
# TERMINAL CONFIGURATION
# =============================================================================

export COLORTERM="truecolor"

if [[ -n "$TMUX" ]]; then
  export TERM="tmux-256color"
else
  export TERM="xterm-256color"
fi

# =============================================================================
# ENVIRONMENT VARIABLES
# =============================================================================

export JAVA_HOME="/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home"
export PYENV_ROOT="$HOME/.pyenv"
export NVM_DIR="$HOME/.nvm"
export PNPM_HOME="$HOME/Library/pnpm"
export PLAYDATE_SDK_PATH="$HOME/Developer/PlaydateSDK"
export ANDROID_HOME="/Volumes/ssd/Android/sdk"
export ANDROID_SDK_ROOT="/Volumes/ssd/Android/sdk"

# Build PATH cleanly
export PATH="$HOME/.local/bin:$HOME/bin:$PYENV_ROOT/bin:$PLAYDATE_SDK_PATH/bin:$PNPM_HOME:$HOME/.local/share/solana/install/active_release/bin:$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"

# =============================================================================
# DEVELOPMENT TOOL INITIALIZATIONS
# =============================================================================

# Python - pyenv
if command -v pyenv >/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# Node - nvm
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  source "$NVM_DIR/nvm.sh"
  [[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"
  # Auto-use default Node if set
  nvm alias default node >/dev/null 2>&1
  nvm use default >/dev/null 2>&1
fi

# Smart directory navigation - zoxide
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init bash)"
fi

# =============================================================================
# PROMPT (using Starship for speed + style)
# =============================================================================

if command -v starship >/dev/null 2>&1; then
  eval "$(starship init bash)"
else
  # Fallback: simple colorful prompt with git branch
  parse_git_branch() {
    git branch 2>/dev/null | grep '^*' | colrm 1 2
  }
  PS1='\[\033[1;32m\]\u@\h\[\033[0m\]:\[\033[1;34m\]\w\[\033[0m\]$(if branch=$(parse_git_branch); then echo " (\033[1;33m$branch\033[0m)"; fi)\n\$ '
fi

# =============================================================================
# ALIASES
# =============================================================================

# File Operations
alias la="ls -la"
alias ll="ls -l"
alias l="ls -CF"

# Editor Shortcuts
alias nv="nvim"
alias vim="nvim"
alias vi="nvim"

# Applications
alias tmux="TERM=screen-256color-bce tmux"

# Dev Helpers
alias g="git"
alias py="python3"
alias pip="pip3"

# =============================================================================
# FUNCTIONS
# =============================================================================

# Create directory and cd into it
mkcd() {
  mkdir -p "$1" && cd "$1" || return
}

# Navigate up multiple directories
up() {
  local levels=${1:-1}
  local path=""
  for ((i = 0; i < levels; i++)); do
    path="../$path"
  done
  cd "$path" || return
}

# Extract various archive formats
extract() {
  if [[ -f "$1" ]]; then
    case "$1" in
    *.tar.bz2) tar xjf "$1" ;;
    *.tar.gz) tar xzf "$1" ;;
    *.bz2) bunzip2 "$1" ;;
    *.rar) unrar x "$1" ;;
    *.gz) gunzip "$1" ;;
    *.tar) tar xf "$1" ;;
    *.tbz2) tar xjf "$1" ;;
    *.tgz) tar xzf "$1" ;;
    *.zip) unzip "$1" ;;
    *.Z) uncompress "$1" ;;
    *.7z) 7z x "$1" ;;
    *) echo "'$1' cannot be extracted" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# =============================================================================
# SECURITY & LOCAL CONFIG
# =============================================================================

# Secrets
[[ -f "$HOME/.bash_secrets" ]] && source "$HOME/.bash_secrets"

# Machine-specific local overrides
[[ -f "$HOME/.bash_local" ]] && source "$HOME/.bash_local"

# =============================================================================
# COMPLETION
# =============================================================================

# Load bash-completion (for git, docker, etc.)
if [ -f /usr/share/bash-completion/bash_completion ]; then
  . /usr/share/bash-completion/bash_completion
elif [ -f /opt/homebrew/etc/bash_completion ]; then
  . /opt/homebrew/etc/bash_completion
fi

# =============================================================================
# END OF CONFIGURATION
# =============================================================================
