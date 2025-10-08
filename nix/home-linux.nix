{ pkgs, ... }: {

  home.packages = with pkgs; [
    xclip
    xsel
  ];

  programs.zsh.promptInit = ''
    PROMPT='%F{yellow}%n@%m%f:%F{blue}%1~%f ❯ '
  '';
}
