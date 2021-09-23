{ config, lib, pkgs, ... }:
let
  cfg = config.flakes;
in with lib; {
  options.flakes = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description =
        ''
          This option enables configuration necessary to use Nix flakes.
        '';
    };
  };

  config = mkIf cfg.enable (mkMerge [{
    nixpkgs.overlays = [
      (self: super: {
        nixUnstable = super.nixUnstable.overrideAttrs (oldAttrs: oldAttrs // {
          patches = [ ./../unset-is-macho.patch ];
          meta = (oldAttrs.meta or {}) // {
            priority = 10;
          };
        });
      })
    ];

    home.packages = with pkgs; [
      nixUnstable
      #(nixUnstable.overrideAttrs (oldAttrs: oldAttrs // {
      #  patches = [ ./../unset-is-macho.patch ];
      #  meta = (oldAttrs.meta or {}) // {
      #    priority = 10;
      #  };
      #}))
      #nixFlakes
    ];

    home.file.nixConf = {
      target = ".config/nix/nix.conf";
      text =
        ''
          experimental-features = nix-command flakes
        '';
    };

    programs.direnv.nix-direnv.enableFlakes = true;
  }]);
}
