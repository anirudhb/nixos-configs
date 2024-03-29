{ pkgs, lib, fenix, nixpkgs-rev, ... }: rec {
  imports = [
    ./flakes.nix
  ];

  caches.cachix = [
    { name = "nix-community"; sha256 = "0m6kb0a0m3pr6bbzqz54x37h5ri121sraj1idfmsrr6prknc7q3x"; }
    { name = "hackclub"; sha256 = "1x4pldwhaibrwxs3n1mjbmjma84llja6f3m7h7z62a6mcrjr0zy1"; }
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Enable flakes!!
  flakes.enable = true;

  nix.package = pkgs.nixVersions.nix_2_16;
  nix.registry.nixpkgs = {
    from = {
      id = "nixpkgs";
      type = "indirect";
    };
    to = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      rev = nixpkgs-rev;
    };
  };

  home.packages = with pkgs; [
    htop
    neofetch
    fortune
    python39

    curl
    aces
    ripgrep
    nix-fi
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

  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal.family = "Portland Mono";
        size = 14;
      };
      selection.save_to_clipboard = true;
      mouse.hide_when_typing = true;
      # snazzy
      draw_bold_text_with_bright_colors = true;
      colors = {
        primary = {
          background = "#282a36";
          foreground = "#eff0eb";
        };
        cursor.cursor = "#97979b";
        selection = {
          text = "#282a36";
          background = "#feffff";
        };
        normal = {
          black = "#282a36";
          red = "#ff5c57";
          green = "#5af78e";
          yellow = "#f3f99d";
          blue = "#57c7ff";
          magenta = "#ff6ac1";
          cyan = "#9aedfe";
          white = "#f1f1f0";
        };
        bright = {
          black = "#686868";
          red = "#ff5c57";
          green = "#5af78e";
          yellow = "#f3f99d";
          blue = "#57c7ff";
          magenta = "#ff6ac1";
          cyan = "#9aedfe";
          white = "#eff0eb";
        };
      };
    };
  };

  programs.tmux = {
    enable = true;
    clock24 = true;
    prefix = "C-a";
    terminal = "screen-256color";
    extraConfig = ''
      set -as terminal-features ",*256col*:RGB"
    '';
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
      "old_haas" = {
        hostname = "45.55.45.5";
        identityFile = "~/.ssh/old_haas_rsa";
      };
      "haas.hackclub.com" = {
        hostname = "haas.hackclub.com";
        identityFile = "~/.ssh/haas";
      };
    };
  };

  programs.neovim = {
    enable = true;
    # see flake.nix
    # package = pkgs.neovim-nightly;
    extraConfig = builtins.readFile ../init.vim;
    extraPackages = with pkgs; [
      fzf
      pyright
      nodePackages.typescript-language-server
      nodePackages.vim-language-server
      terraform-ls
      fenix.rust-analyzer
      clang-tools
    ];
    extraPython3Packages = ps: with ps; [
      pynvim
    ];
    plugins = with pkgs.vimPlugins; [
      deoplete-nvim
      ale

      nvim-lspconfig
      deoplete-lsp
      lsp_signature-nvim
      fidget-nvim

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
