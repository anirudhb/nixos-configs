{ pkgs, lib, ... }:

rec {
  programs.zsh = {
    enable = true;
    # FIXME: Uncomment this once we get to 21.11
    # enableSyntaxHighlighting = true;
    # FIXME: powerlevel10k
    # plugins = [
    #   {
    #     name = "powerlevel10k";
    #     src = pkgs.fetchFromGitHub {
    #       owner = "romkatv";
    #       repo = "powerlevel10k";
    #       rev = "32e76e772173f1d2856ee4002f21607523221ce7";
    #       sha256 = "03krpp3zxpvr8zfgpcj2gmxfgxf0jlxg1ic929i229v6q6qw5isd";
    #     };
    #   }
    # ];
    oh-my-zsh = {
      enable = true;
      # FIXME: zsh-syntax-highlighting
      # plugins = [
      #   "zsh-syntax-highlighting"
      # ];
      # theme = "powerlevel10k/powerlevel10k";
    };
    initExtraFirst = ''
source ~/.profile
'';
  };

  # GPG pinentry
  home.packages = with pkgs; [
    pinentry_mac
  ];

  home.file.".gnupg/gpg-agent.conf".text = ''
    pinentry-program ${pkgs.pinentry_mac}/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac
  '';
}
