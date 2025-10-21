{ config, pkgs, ... }:

{
  home.username = "root"; 
  home.homeDirectory = "/root";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    git
    gh
    lazygit
    tmux
    neovim
    fzf
    fd
    ripgrep
    openssh
    curl
    unzip
    wget
  ];

  programs.git = {
    enable = true;
    userName = "Jack Kitto";
    userEmail = "jack@kitto.sh";
  };

  programs.neovim = {
    enable = true;
    vimAlias = true;
  };

  home.stateVersion = "24.05"; 
}
