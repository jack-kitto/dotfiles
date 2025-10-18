#!/usr/bin/env zsh
# =============================================================================
# .zshrc - Zsh Configuration File
# =============================================================================
# A clean, organized, and maintainable zsh configuration
# Last updated: 2025-09-11
# =============================================================================

# =============================================================================
# PERFORMANCE & COMPATIBILITY
# =============================================================================

# Skip global compinit for faster startup (Oh-My-Zsh will handle it)
skip_global_compinit=1

# Ensure we're running in a compatible shell
[[ -n "$ZSH_VERSION" ]] || return

# =============================================================================
# OH-MY-ZSH CONFIGURATION
# =============================================================================

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

# Core plugins for productivity and syntax highlighting
plugins=(
  git                    # Git aliases and functions
  zsh-autosuggestions   # Fish-like autosuggestions
  zsh-syntax-highlighting # Syntax highlighting for commands
  command-time # Command timing
)

# Load Oh-My-Zsh framework (only if it exists)
[[ -f "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"

# =============================================================================
# TERMINAL CONFIGURATION
# =============================================================================

# Terminal colors and capabilities
export COLORTERM="truecolor"

# Tmux-aware terminal configuration
if [[ -n "$TMUX" ]]; then
  export TERM="tmux-256color"
else
  export TERM="xterm-256color"
fi

# =============================================================================
# ENVIRONMENT VARIABLES
# =============================================================================

# Development Tools Home Directories
export JAVA_HOME="/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home"
export PYENV_ROOT="$HOME/.pyenv"
export NVM_DIR="$HOME/.nvm"
export PNPM_HOME="$HOME/Library/pnpm"
export PLAYDATE_SDK_PATH="$HOME/Developer/PlaydateSDK"
export PATH="/Applications/Android Studio.app/Contents/MacOS:$PATH"
export PATH="$HOME/bin:$PATH"


export PATH="/Users/jack/.local/share/solana/install/active_release/bin:$PATH"
export ANDROID_HOME=/Volumes/ssd/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

# Shell Configuration
export RBENV_SHELL=zsh

# =============================================================================
# PATH CONFIGURATION
# =============================================================================

# Ensure PATH uniqueness and build systematically
typeset -U path

# Add development tools to PATH in order of precedence
path=(
  "$PYENV_ROOT/bin"                                      # Python version manager
  "$HOME/.local/bin"                                     # Local user binaries
  "$PLAYDATE_SDK_PATH/bin"                              # Playdate SDK tools
  "$PNPM_HOME"                                          # pnpm package manager
  "$HOME/.local/share/solana/install/active_release/bin" # Solana CLI tools
  $path                                                  # Preserve existing PATH
)

export PATH

# =============================================================================
# DEVELOPMENT TOOL INITIALIZATIONS
# =============================================================================

# Python Environment Manager (pyenv)
if command -v pyenv >/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# Node Version Manager (nvm)
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  source "$NVM_DIR/nvm.sh"

  # Auto-load Node.js completion
  [[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"

  # Set and use default Node.js version
  nvm alias default 20 >/dev/null 2>&1
  nvm use default >/dev/null 2>&1
fi

# Ruby Environment Manager (chruby)
if [[ -s "/opt/homebrew/opt/chruby/share/chruby/chruby.sh" ]]; then
  source "/opt/homebrew/opt/chruby/share/chruby/chruby.sh"
  # Auto-switch Ruby versions based on .ruby-version files
  [[ -s "/opt/homebrew/opt/chruby/share/chruby/auto.sh" ]] && \
    source "/opt/homebrew/opt/chruby/share/chruby/auto.sh"
fi

# Ruby Environment Manager (rbenv) - alternative to chruby
if [[ -s '/opt/homebrew/Cellar/rbenv/1.2.0/libexec/../completions/rbenv.zsh' ]]; then
  source '/opt/homebrew/Cellar/rbenv/1.2.0/libexec/../completions/rbenv.zsh'
  command rbenv rehash 2>/dev/null
fi

# Smart Directory Navigation (zoxide)
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# =============================================================================
# ALIASES
# =============================================================================

# File System Operations
alias la="ls -la"          # List all files in long format
alias ll="ls -l"           # List files in long format
alias l="ls -CF"           # List files in columns

# Editor Shortcuts
alias nv="nvim"            # Neovim shortcut
alias vim="nvim"           # Use Neovim instead of vim
alias vi="nvim"            # Use Neovim instead of vi

# Application Shortcuts
alias love="/Applications/love.app/Contents/MacOS/love"  # Love2D game engine
alias tmux="TERM=screen-256color-bce tmux"              # Tmux with proper colors

# Development Shortcuts
alias g="git"              # Quick git access
alias py="python3"         # Python 3 shortcut
alias pip="pip3"           # Use pip3 by default
alias cd="z"

# =============================================================================
# UTILITY FUNCTIONS
# =============================================================================

# Create directory and navigate to it
function mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Quick directory navigation up the tree
function up() {
  local levels=${1:-1}
  local path=""
  for ((i=0; i<levels; i++)); do
    path="../$path"
  done
  cd "$path" || return
}

# Extract various archive formats
function extract() {
  if [[ -f "$1" ]]; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1"     ;;
      *.tar.gz)    tar xzf "$1"     ;;
      *.bz2)       bunzip2 "$1"     ;;
      *.rar)       unrar x "$1"     ;;
      *.gz)        gunzip "$1"      ;;
      *.tar)       tar xf "$1"      ;;
      *.tbz2)      tar xjf "$1"     ;;
      *.tgz)       tar xzf "$1"     ;;
      *.zip)       unzip "$1"       ;;
      *.Z)         uncompress "$1"  ;;
      *.7z)        7z x "$1"        ;;
      *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# =============================================================================
# SECURITY & SENSITIVE CONFIGURATION
# =============================================================================

# Load sensitive environment variables from a separate file
# This keeps API keys, tokens, and secrets out of version control
# Create ~/.zshrc_secrets for sensitive variables like:
# export OPENAI_API_KEY="your-key-here"
# export AWS_ACCESS_KEY_ID="your-key-here"
[[ -f "$HOME/.zshrc_secrets" ]] && source "$HOME/.zshrc_secrets"

# =============================================================================
# LOCAL CUSTOMIZATIONS
# =============================================================================

# Load machine-specific configurations
# Create ~/.zshrc_local for configurations that vary by machine:
# - Different PATH entries
# - Machine-specific aliases
# - Local development settings
[[ -f "$HOME/.zshrc_local" ]] && source "$HOME/.zshrc_local"

# =============================================================================
# COMPLETION SYSTEM
# =============================================================================

# Enable completion system (if not already done by Oh-My-Zsh)
autoload -Uz compinit
compinit

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# =====================================
# Automatic macOS notifications for long commands
# Works with zsh + tmux + macOS + terminal-notifier
# =====================================

# Time threshold (in seconds)
LONG_THRESHOLD=10

preexec() {
  TIMER=$SECONDS
}

precmd() {
  local exit_status=$?
  if [[ -n "$TIMER" ]]; then
    local elapsed=$((SECONDS - TIMER))
    if (( elapsed > LONG_THRESHOLD )); then
      local title="Command finished"
      local msg="📁 $(basename "$PWD") — took ${elapsed}s (exit $exit_status)"

      if command -v terminal-notifier >/dev/null 2>&1; then
        # macOS notification (sound and ignore DnD)
        terminal-notifier \
          -title "$title" \
          -message "$msg" \
          -group "zshnotify" \
          -sound "heroine" \
          -ignoreDnD
      else
        # Fallback if terminal-notifier is not installed
        osascript -e "display notification \"$msg\" with title \"$title\" sound name \"default\""
      fi
    fi
    unset TIMER
  fi
}

export PATH="/Users/jack/.local/share/solana/install/active_release/bin:$PATH"
export ANDROID_HOME=/Volumes/ssd/Android/sdk
export ANDROID_SDK_ROOT=/Volumes/ssd/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH

# =============================================================================
# END OF CONFIGURATION
# =============================================================================
