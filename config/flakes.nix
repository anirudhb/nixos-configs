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
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
  }]);
}
