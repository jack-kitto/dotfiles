{ pkgs, ... }: {

  # Tools only meaningful on macOS
  home.packages = with pkgs; [
    reattach-to-user-namespace  # tmux clipboard
    terminal-notifier
  ];

  # macOS‑specific settings
  programs.zsh.promptInit = ''
    autoload -U promptinit; promptinit
    PROMPT='%F{green}%n@%m%f:%F{blue}%1~%f ❯ '
  '';
}
