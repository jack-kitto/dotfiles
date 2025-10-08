{ pkgs, ... }:

{
  home.username = "jack";
  home.homeDirectory = builtins.getEnv "HOME";

  programs.zsh.enable = true;

  home.packages = with pkgs; [
    git neovim tmux fzf ripgrep fd bat jq tree
    watch unzip gzip coreutils findutils gawk gnused
    zoxide rsync wget curl htop ncdu gh
    imagemagick ffmpeg tesseract pandoc
    gnumake cmake pkg-config gnupg
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    PATH   = "$HOME/.local/bin:$PATH";
  };

  programs.git = {
    enable = true;
    userName  = "Jack Kitto";
    userEmail = "jack.kitto@thenod.app";
  };

  programs.tmux.enable = true;
  programs.neovim.enable = true;
  programs.fzf.enable = true;
  programs.bat.enable = true;
  programs.zoxide.enable = true;
}
