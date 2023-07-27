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
              #neovim-nightly-overlay.overlay
              #(import ./pkgs/neovim-nightly.nix)
              hackclub-overlay.overlay.x86_64-darwin
              (import ./overlay.nix)
              (let
                pkgs = nixpkgs.legacyPackages.x86_64-darwin;
                patchedNeovimTree = pkgs.applyPatches {
                  src = pkgs.fetchFromGitHub {
                    owner = "neovim";
                    repo = "neovim";
                    rev = "8fe9f41f7f9da2009d11855ec0548b9dbe548a69";
                    hash = "sha256-P9A8ie/4zA5Hhk3OpJxzmqTefKeVxSQUOSMTxbyBM8U=";
                  };
                  patches = [ ./pkgs/neovim-flake.nix.patch ];
                };
                narHash = pkgs.lib.fileContents (pkgs.runCommand "${patchedNeovimTree.name}-narHash" {} ''
                  ${pkgs.nixVersions.nix_2_16}/bin/nix --extra-experimental-features nix-command hash path --sri ${patchedNeovimTree} > $out
                '');
                neovimOverlay = (builtins.getFlake "file+file://${builtins.unsafeDiscardStringContext patchedNeovimTree}?dir=contrib&narHash=${builtins.unsafeDiscardStringContext narHash}").outputs.overlay;
              in
                final: prev: let
                  out1 = neovimOverlay prev prev;
                in out1 // {
                  neovim-unwrapped = out1.neovim;
                  neovim-nightly = out1.neovim;
                })
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
