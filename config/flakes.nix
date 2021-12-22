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
    home.packages = with pkgs; [
      nixUnstable
    ];

    home.file.nixConf = {
      target = ".config/nix/nix.conf";
      text =
        ''
          experimental-features = nix-command flakes
        '';
    };
  }]);
}
