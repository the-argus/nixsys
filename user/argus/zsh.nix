{

  programs.zsh = {
    syntaxHighlighting.enable = true;
    
    historyIgnore = [ "exit" "ls" "history" "clear" "fg" "cd" ];
    
    shellAliases = {
        sysconf = "sudo nvim /etc/nixos/configuration.nix";
        nf = "neofetch";
        fm = "ranger";
        search = "nix search nixpkgs";
        matrix = "tmatrix -c default -C yellow -s 60 -f 0.2,0.3 -g 10,20 -l 1,50 -t \"hello, argus.\"";
        umatrix = "unimatrix -a -c yellow -f -s 95 -l aAcCgGkknnrR";
        vim = "nvim";
        batt = "cat /sys/class/power_supply/BAT0/capacity";

        # unused mostly
        cageff = "cage \"/bin/firefox -p Unconfigured\"";
        awesomedoc = "firefox ${pkgs.awesome}/share/doc/awesome/doc/index.html & disown";
    };
    
    plugins = [
      {
        name = "zsh-autocomplete";
        src = pkgs.zsh-autocomplete;
      }
      {
        name = "zsh-nix-shell";
        src = pkgs.zsh-nix-shell;
      }
    ];
  };

  # zshrc
  pkgs.zsh.initExtra = ''
    bindkey "''${key[Up]}" up-line-or-search
  '';
}
