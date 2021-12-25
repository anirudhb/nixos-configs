{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    declCachix.url = "github:jonascarpay/declarative-cachix";
    hackclub-overlay.url = "github:hackclub/nix-overlay";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { self, nixpkgs, home-manager
            , declCachix
            , hackclub-overlay
            , neovim-nightly-overlay }: {
    homeConfigurations = {
      anirudh = home-manager.lib.homeManagerConfiguration {
        system = "x86_64-darwin";
        homeDirectory = "/Users/anirudh";
        username = "anirudh";
        stateVersion = "21.05";
        configuration = {
          imports = [
            declCachix.homeManagerModules.declarative-cachix-experimental
            ./config/home.nix
            ./config/macos.nix
          ];
          nixpkgs.overlays = [
            neovim-nightly-overlay.overlay
            hackclub-overlay.overlay.x86_64-darwin
            (import ./overlay.nix)
          ];
        };
      };
    };
  };
}
