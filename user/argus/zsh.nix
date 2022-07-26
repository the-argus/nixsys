{ pkgs, ... }:
{
  programs.zsh =
    let
      dDir = ".config/zsh";
    in
    {
      enable = true;

      autocd = true;

      dotDir = dDir;
      enableCompletion = true;
      enableSyntaxHighlighting = true;

      history = {
        path = "$HOME/${dDir}/histfile";
        ignorePatterns = [ "ls *" "cd *" "exit" "clear" "fg" ];
        ignoreDups = true;
        share = true;
      };

      shellAliases = {
        # regular aliases
        nf = "neofetch";
        fm = "ranger";
        search = "nix search nixpkgs";
        matrix = "tmatrix -c default -C yellow -s 60 -f 0.2,0.3 -g 10,20 -l 1,50 -t \"hello, argus.\"";
        umatrix = "unimatrix -a -c yellow -f -s 95 -l aAcCgGkknnrR";
        vim = "nvim";
	dvim = "XDG_CONFIG_HOME=/home/argus/.local/src/ nvim"; # use my non-nix configuration for debugging
        batt = "cat /sys/class/power_supply/BAT0/capacity";

        # unused mostly
        cageff = "cage \"/bin/firefox -p Unconfigured\"";
        awesomedoc = "firefox ${pkgs.awesome.doc}/share/doc/awesome/doc/index.html & disown";
      };

      zplug = {
        enable = true;
        plugins = [
          { name = "marlonrichert/zsh-autocomplete"; }
          # { name = "Vifon/deer"; tags = [use:deer]; }
          # { name = "zsh-users/zsh-completions"; }
          # { name = "spwhitt/nix-zsh-completions"; }
          { name = "hlissner/zsh-autopair"; }
          { name = "the-argus/my-zsh"; }
        ];
      };

      plugins =
        [
          {
            name = "zsh-nix-shell";
            file = "nix-shell.plugin.zsh";
            src = pkgs.fetchFromGitHub {
              owner = "chisui";
              repo = "zsh-nix-shell";
              rev = "v0.5.0";
              sha256 = "0za4aiwwrlawnia4f29msk822rj9bgcygw6a8a6iikiwzjjz0g91";
            };
          }
        ];

      completionInit = ''
        # compatibility between nix and autocomplete
        bindkey "''${key[Up]}" up-line-or-search

        # minimum number of characters to type before autocomplete
        zstyle ':autocomplete:*' min-input 1
        # only insert up to common characters
        zstyle ':autocomplete:*' insert-unambiguous yes
        # dont move prompt up to make room for autocomplete very much
        zstyle ':autocomplete:*' list-lines 4
        # tab multiple times to move through menu
        zstyle ':autocomplete:*' widget-style menu-select
      '';


      initExtra = ''
        # INCLUDES---------------------------------------------------------------------

        # these should both be moved to flakes instead of floating around in other places
        source $HOME/.aliases
        # source $HOME/.local/src/zsh-prompt/minimal.zsh

        autoload -U deer

        # CONFIG ----------------------------------------------------------------------

        #
        # DEER CONFIG
        #
        zle -N deer
        bindkey '\ek' deer
        zstyle ':deer:' height 35
        zstyle :deer: show_hidden yes


        #
        # PROMPT CONFIG
        #

        PROMPT_START=""
        NAME_HOST_SEPARATOR=" at "
        HOST_DIR_SEPARATOR=" in "
        MODULE_SEPARATOR_START=" "
        MODULE_SEPARATOR_END=" "
        NEWLINE_PROMPT_START="❯ "
        MAIN_MODULE_SEPARATOR_START=""
        MAIN_MODULE_SEPARATOR_END=""
        GIT_MODULE_SEPARATOR_START="on "
        GIT_MODULE_SEPARATOR_START="$MODULE_SEPARATOR_START$GIT_MODULE_SEPARATOR_START"
        GIT_MODULE_SEPARATOR_END=""
        PYTHON_MODULE_SEPARATOR_START="using python "
        PYTHON_MODULE_SEPARATOR_START="$MODULE_SEPARATOR_START$PYTHON_MODULE_SEPARATOR_START"
        PYTHON_MODULE_SEPARATOR_END=""
        TIME_MODULE_SEPARATOR_START="took "
        TIME_MODULE_SEPARATOR_START="$MODULE_SEPARATOR_START$TIME_MODULE_SEPARATOR_START"
        TIME_MODULE_SEPARATOR_END=""
        NIX_MODULE_SEPARATOR_START="using "
        NIX_MODULE_SEPARATOR_START="$MODULE_SEPARATOR_START$NIX_MODULE_SEPARATOR_START"
        NIX_MODULE_SEPARATOR_END=""

        USER_HOST_SEP_STYLE="$REGULAR"
        HOST_DIR_SEP_STYLE="$REGULAR"
        MOD_SEP_STYLE="$REGULAR"

        # prompt module order
        prompt='$(_start_module)$(_main_module)$(_nix_module)$(_time_module)$(_git_module)$(_python_module)'$'\n''$(_newline_module)'
      '';
    };
}
