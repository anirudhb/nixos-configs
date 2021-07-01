{ config, pkgs, lib, ... }:

rec {
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "anirudh";
  home.homeDirectory = "/home/anirudh";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.05";

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "vscode"
    "google-chrome"
    "slack"
    "discord"
  ];

  home.packages = with pkgs; [
    htop
    neofetch
    fortune
    firefox
    python39
    clang_12
    neovim
    neovim-qt
    curl
    vscode
    slack
    google-chrome
    discord
  ];

  programs.git = {
    enable = true;
    userName = "anirudhb";
    userEmail = "anirudhb@users.noreply.github.com";
    signing = {
      key = "D71E36F1EDC5ADCB";
      signByDefault = true;
    };
  };

  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "qt";
  };

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        identityFile = "~/.ssh/github_rsa";
      };
    };
  };
}
