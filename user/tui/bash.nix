{pkgs, ...}: let
in {
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
    };
    enableBashIntegration = true;
    enableZshIntegration = false;
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;

    shellAliases = {
      # regular aliases
      nf = "neofetch";
      search = "nix search nixpkgs";
      fim = "nvim $(fd -t f | fzf)";

      # unused mostly
      ix = "curl -F 'f:1=<-' ix.io";
      rm = "rm -i";
      nocolor = ''sed "s/\x1B\[[0-9;]\{1,\}[A-Za-z]//g"'';
      sudo = "sudo -A";
      all = "git commit -am";
      cat = "bat";
      df = "duf";
      back = "z -";
      cd = "z";
    };

    sessionVariables = {
      SUDO_ASKPASS = "${pkgs.myPackages.sudo-askpass}/bin/sudo-askpass";
    };

    initExtra = ''
      eval "$(starship init bash)"
      eval "$(zoxide init bash)"
      eval "$(mcfly init zsh)"

      function lsd () {
        command lsd $@ --group-dirs=first --color=auto
      }
    '';

    historyControl = ["erasedups" "ignoredups" "ignorespace"];
  };

  home.packages = with pkgs; [
    zoxide
    fzf
    mcfly
    ripgrep
    fd
    lsd
    duf
    bat
    tldr
  ];
}
