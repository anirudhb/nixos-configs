{ pkgs, lib, ... }:
let

  isMacOS = lib.hasSuffix "darwin" builtins.currentSystem;

in

rec {
  imports = [
    (
      let
        declCachix = builtins.fetchTarball "https://github.com/jonascarpay/declarative-cachix/archive/a2aead56e21e81e3eda1dc58ac2d5e1dc4bf05d7.tar.gz";
      in import "${declCachix}/home-manager.nix"
    )
  ] ++ (if isMacOS then [ ./macos.nix ] else []);

  caches.cachix = [
    "nix-community"
  ];

  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
    }))
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "anirudh";
  home.homeDirectory = if isMacOS then "/Users/anirudh" else "/home/anirudh";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.05";

  home.packages = with pkgs; [
    htop
    neofetch
    fortune
    python39
    clang_12
    curl
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

  #services.gpg-agent = {
  #  enable = true;
  #  pinentryFlavor = "qt";
  #};

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        identityFile = "~/.ssh/github_rsa";
      };
    };
  };

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;
    extraConfig = builtins.readFile ../init.vim;
    extraPackages = [ pkgs.fzf ];
    extraPython3Packages = ps: with ps; [
      pynvim
    ];
    configure = {
      plug.plugins = with pkgs.vimPlugins; [
        deoplete-nvim
        ale

        nvim-lspconfig
        deoplete-lsp
        lsp_signature-nvim

        float-preview-nvim

        fzf-vim
        nerdtree

        base16-vim

        vim-airline
        vim-airline-themes

        vim-polyglot
        vim-flutter
        vim-vsnip
        vim-vsnip-integ

        vim-fugitive

        (pkgs.vimUtils.buildVimPlugin {
          name = "recents-nvim";
          src = pkgs.fetchFromGitHub {
            owner = "anirudhb";
            repo = "recents.nvim";
            rev = "51fe3521d6fa2fae5d383329305b4261ea2442de";
            sha256 = "15s88fng72zm28fj18b9zk5slwmkxiqr92fsj4hfyva94w960a78";
          };
        })
      ];
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = true;
    };
  };

  #services.lorri.enable = true;

  home.file.".bashrc".text = builtins.readFile ../bashrc.sh;
  #home.file.".zshrc".text = builtins.readFile ../zshrc.sh;
  home.sessionVariables.EDITOR = "nvim";
}
