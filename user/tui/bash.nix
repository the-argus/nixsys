{pkgs, ...}: let
in {
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
    };
    enableBashIntegration = true;
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
      eval "$(${pkgs.zoxide}/bin/zoxide init bash)"
      eval "$(${pkgs.mcfly}/bin/mcfly init bash)"
      eval "$(${pkgs.direnv}/bin/direnv hook bash)"

      function lsd () {
        lsd --color=auto --group-dirs=first $@
      }
      function lsdl () {
        lsd -la $@
      }

      function ls () {
        command ls --color=auto --group-directories-first $@
      }
      function lsl () {
      	command ls -la --color=auto --group-directories-first $@ | command grep "^d" && ls -la $1 | command grep -v "^d"
      }


      function ip () { command ip -color=auto "$@"; }

      lfcd () {
        tmp="$(mktemp)"
        lf -last-dir-path="$tmp" "$@"
        if [ -f "$tmp" ]; then
          dir="$(cat "$tmp")"
          rm -f "$tmp"
          if [ -d "$dir" ]; then
            if [ "$dir" != "$(pwd)" ]; then
              cd "$dir"
            fi
          fi
        fi
      }
    '';

    historyControl = ["erasedups" "ignoredups" "ignorespace"];
  };

  home.packages = with pkgs; [
    direnv
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
