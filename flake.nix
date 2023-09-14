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
    fenix.url = "github:nix-community/fenix";
  };

  outputs = { self, nixpkgs, home-manager
            , declCachix
            , hackclub-overlay
            , neovim-nightly-overlay
            , fenix }: {
    homeConfigurations = {
      anirudh = home-manager.lib.homeManagerConfiguration rec {
        pkgs = nixpkgs.legacyPackages.x86_64-darwin;
        modules = [
          declCachix.homeManagerModules.declarative-cachix-experimental
          ./config/home.nix
          ./config/macos.nix
          {
            nixpkgs.overlays = [
              # nix-community/neovim-nightly-overlay#176
              # neovim-nightly-overlay.overlay
              hackclub-overlay.overlay.x86_64-darwin
              (import ./overlay.nix)
            ];
          }
          {
            home = {
              username = "anirudh";
              homeDirectory = "/Users/anirudh";
              stateVersion = "21.05";
            };
          }
        ];
        extraSpecialArgs = {
          fenix = fenix.packages.x86_64-darwin;
          nixpkgs-rev = let
            lockFile = builtins.fromJSON (builtins.readFile ./flake.lock);
            rootNode = lockFile.nodes.${lockFile.root};
            nixpkgsNode = lockFile.nodes.${rootNode.inputs.nixpkgs};
          in nixpkgsNode.locked.rev;
        };
      };
    };
  };
}
