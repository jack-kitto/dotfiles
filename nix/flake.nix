{
  description = "Jack Kitto — Base Nix environment (Darwin + Linux)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    darwin.url = "github:LnL7/nix-darwin";
  };

  outputs = { self, nixpkgs, home-manager, darwin }:
    let
      mkHome = { system, extraModules ? [ ] }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { inherit system; };
          modules = [ ./home-common.nix ] ++ extraModules;
        };
    in {
      # macOS ---------------------------------------------------
      darwinConfigurations."jack-macos" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          home-manager.darwinModules.home-manager
          {
            users.users.jack = { home = /Users/jack; };
            home-manager.users.jack = import ./home-common.nix;
          }
          ./home-darwin.nix
        ];
      };

      # Linux ---------------------------------------------------
      homeConfigurations."jack-linux" = mkHome {
        system = "x86_64-linux";
        extraModules = [ ./home-linux.nix ];
      };
    };
}
