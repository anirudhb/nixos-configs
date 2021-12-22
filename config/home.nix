{ pkgs, lib, ... }: rec {
  imports = [
    ./flakes.nix
  ]

  caches.cachix = [
    { name = "nix-community"; sha256 = "00lpx4znr4dd0cc4w4q8fl97bdp7q19z1d3p50hcfxy26jz5g21g"; }
    { name = "hackclub"; sha256 = "13rfgdf1kkgm3ss9zg6kz9kahwk0a5k0ij9zkvgvrqdsnxn7jwwg"; }
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Enable flakes!!
  flakes.enable = true;

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

  programs.kitty = {
    enable = true;
    font = {
      name = "Portland Mono";
      size = 14;
    };
    settings = {
      font_features = "PortlandMono-Regular +liga +calt";
      adjust_column_width = "100%";
      adjust_line_height = "100%";
      copy_on_select = "yes";
      macos_option_as_alt = "yes";
      macos_thicken_font = "0.75";
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
      "haas.hackclub.com" = {
        hostname = "haas.hackclub.com";
        identityFile = "~/.ssh/old_haas_rsa";
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
