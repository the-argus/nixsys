{
  pkgs,
  username,
  settings,
  ...
}: {
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
    };
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  # make starship work with bash (nix develop)
  home.file.".bashrc".text = ''
    #!/bin/sh
    eval "$(starship init bash)"
  '';

  programs.zsh = let
    dDir = ".config/zsh";
  in {
    enable = true;

    autocd = true;

    dotDir = dDir;
    enableCompletion = true;
    enableSyntaxHighlighting = true;

    history = {
      path = "$HOME/${dDir}/histfile";
      ignorePatterns = ["ls *" "exit" "clear" "fg"];
      ignoreDups = true;
      share = true;
    };

    shellAliases =
      {
        # regular aliases
        nf = "neofetch";
        fm = "ranger";
        search = "nix search nixpkgs";
        matrix = "tmatrix -c default -C yellow -s 60 -f 0.2,0.3 -g 10,20 -l 1,50 -t \"hello, ${username}.\"";
        umatrix = "unimatrix -a -c yellow -f -s 95 -l aAcCgGkknnrR";
        vim = "nvim";
        dvim = "XDG_CONFIG_HOME=/home/${username}/.local/src/ nvim"; # use my non-nix configuration for debugging
        batt = "cat /sys/class/power_supply/BAT0/capacity";

        # unused mostly
        cageff = "cage \"/bin/firefox -p Unconfigured\"";
        awesomedoc = "firefox ${pkgs.awesome.doc}/share/doc/awesome/doc/index.html & disown";
        gnome = "XDG_SESSION_TYPE=wayland dbus-run-session -- gnome-shell --display-server --wayland";
        ix = "curl -F 'f:1=<-' ix.io";
      }
      // (pkgs.callPackage ./lib/xorg.nix {inherit settings;}).startxAliases;

    zplug = {
      enable = true;
      plugins = [
        # { name = "the-argus/my-zsh"; }
        # {name = "marlonrichert/zsh-autocomplete";}
        {
          name = "Vifon/deer";
          tags = [use:deer];
        }
        {name = "zsh-users/zsh-completions";}
        {name = "spwhitt/nix-zsh-completions";}
        {name = "hlissner/zsh-autopair";}
      ];
    };

    plugins = [
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

      # hole in reproducability bc i like to add aliases quickly
      [ -f  "$HOME/.config/aliasrc" ] && source "$HOME/.config/aliasrc"

      function open () {
      	xdg-open "$@">/dev/null 2>&1
      }

      function ls () { command ls --color=auto --group-directories-first "$@"; }

      function lsl () {
      	ls -la --color=always $1 | command grep "^d" && ls -la $1 | command grep -v "^d"
      }

      function diff () { command diff --color=auto "$@"; }

      function grep () { command grep "$@" --color=always; }

      function ip () { command ip -color=auto "$@"; }

      function pc () { sudo pacman --color always "$@"; }

      function pacman () { command pacman --color always "$@"; }

      duk ()
      {
         sudo du -k "$@" | sort -n
      }

      function compress () {
          ffmpeg \
              -i "$1" \
              -vcodec h264 \
              -acodec mp2 \
              COMPRESSED-$1;
          }

      function ytd () { youtube-dl -f bestvideo+bestaudio --merge-output-format mkv --all-subs --cookies ~/.scripts/youtube.com_cookies.txt "$1"; }

      function record () {
          ffmpeg -y \
          -video_size 1920x1080 \
          -framerate 24 -f x11grab -i :0.0 \
          -f pulse -ac 2 -i default \
          $HOME/Screenshots/screenrecord_`date '+%Y-%m-%d_%H-%M-%S'`.mp4 \
          &> /tmp/screenrecord_`date '+%Y-%m-%d_%H-%M-%S'`.log
      }

      # makes files with special characters compatible with fat and exfat
      function filecompat () {
          if [[ "$1" == "" ]]; then
            echo "provide a directory to make files compatible in."
          fi
          local total=0
          for file in "$1"/*; do
            if [[ -d $file ]]; then
              continue
            fi
            # new_filename=$(echo $file | tr -dc '[:alnum:]\n\r')
            new_filename=${"$\{file//[^[:alnum:]]/}"}
            if [[ $file == $new_filename ]]; then
              continue
            fi
            mv -- "$file" "$new_filename"
            total=$((total + 1))
          done

          echo "renamed $total files."
      }

      function lock () {
          sleep 0.2

          ${pkgs.i3lock-fancy}/bin/i3lock-fancy -f "Fira-Code-Regular-Nerd-Font-Complete" -t "hello, argus."

          pactl set-sink-mute @DEFAULT_SINK@ on
          ~/.local/bin/volume.sh refresh
      }

      autoload -U deer

      # CONFIG ----------------------------------------------------------------------

      #
      # DEER CONFIG
      #
      zle -N deer
      bindkey '\ek' deer
      zstyle ':deer:' height 35
      zstyle :deer: show_hidden yes


      eval "$(${pkgs.direnv}/bin/direnv hook zsh)"


      #
      # PROMPT CONFIG
      #

      # PROMPT_START=""
      # NAME_HOST_SEPARATOR=" at "
      # HOST_DIR_SEPARATOR=" in "
      # MODULE_SEPARATOR_START=" "
      # MODULE_SEPARATOR_END=" "
      # NEWLINE_PROMPT_START="❯ "
      # MAIN_MODULE_SEPARATOR_START=""
      # MAIN_MODULE_SEPARATOR_END=""
      # GIT_MODULE_SEPARATOR_START="on "
      # GIT_MODULE_SEPARATOR_START="$MODULE_SEPARATOR_START$GIT_MODULE_SEPARATOR_START"
      # GIT_MODULE_SEPARATOR_END=""
      # PYTHON_MODULE_SEPARATOR_START="using python "
      # PYTHON_MODULE_SEPARATOR_START="$MODULE_SEPARATOR_START$PYTHON_MODULE_SEPARATOR_START"
      # PYTHON_MODULE_SEPARATOR_END=""
      # TIME_MODULE_SEPARATOR_START="took "
      # TIME_MODULE_SEPARATOR_START="$MODULE_SEPARATOR_START$TIME_MODULE_SEPARATOR_START"
      # TIME_MODULE_SEPARATOR_END=""
      # NIX_MODULE_SEPARATOR_START="using "
      # NIX_MODULE_SEPARATOR_START="$MODULE_SEPARATOR_START$NIX_MODULE_SEPARATOR_START"
      # NIX_MODULE_SEPARATOR_END=""
      #
      # USER_HOST_SEP_STYLE="$REGULAR"
      # HOST_DIR_SEP_STYLE="$REGULAR"
      # MOD_SEP_STYLE="$REGULAR"
      #
      # # prompt module order
      # prompt='$(_start_module)$(_main_module)$(_nix_module)$(_time_module)$(_git_module)$(_python_module)'$'\n''$(_newline_module)'
    '';
  };
}
