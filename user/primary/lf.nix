{pkgs, ...}: let
  iconsfile = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/gokcehan/lf/b47cf6d5a525c39db268c2f7b77e2b7497843b17/etc/icons.example";
    sha256 = "04jnldz0y2fj4ymypzmvs7jjbvvjrwzdp99qp9r12syfk65nh9cn";
  };

  cleaner = pkgs.writeShellScript "lf-cleaner.sh" ''
    kitty +icat --clear --silent --transfer-mode file
  '';

  previewer = pkgs.writeShellScript "lf-previewer.sh" ''
    case "$1" in
      *.tar*) tar tf "$1";;
      *.zip) unzip -l "$1";;
      *.rar) unrar l "$1";;
      *.7z) 7z l "$1";;
      *.pdf) ${pkgs.poppler_utils}/bin/pdftotext "$1" -;;
      *.md) ${pkgs.glow}/bin/glow "$1";;
      *) ${pkgs.highlight}/bin/highlight -O ansi "$1";;
    esac
  '';

  sandbox = pkgs.writeShellScript "lf-sandbox.sh" ''
    # kitty previews
    if [[ "$( ${pkgs.file}/bin/file -Lb --mime-type "$1")" =~ ^image ]]; then
      file=$1
      w=$2
      h=$3
      x=$4
      y=$5
      kitty +icat --silent --transfer-mode file --place "${"\${w}x\${h}@\${x}x\${y}"}" "$file"
      exit 1
    fi
    set -euo pipefail
    (
      exec ${pkgs.bubblewrap}/bin/bwrap \
       --proc /proc \
       --dev /dev  \
       --ro-bind / / \
       --unshare-all \
       --new-session \
       ${pkgs.runtimeShell} ${previewer} "$@"
    )
  '';
in {
  home.file.".config/lf/icons".source = iconsfile;
  programs.lf = {
    enable = true;
    settings = {
      drawbox = true;
      dirfirst = true;
      icons = true;
      ignorecase = true;
      preview = true;
      shell = "${pkgs.dash}/bin/dash";
      shellopts = "-eu";
      tabstop = 2;
      info = "size";
    };
    previewer = {
      source = sandbox;
      keybinding = "i";
    };
    extraConfig = ''
      set cleaner ${cleaner}

      ${"\${{"}
        w=$(tput cols)
        if [ $w -le 160 ]; then
          lf -remote "send $id set ratios 1:2"
        else
          lf -remote "send $id set ratios 1:2:3"
        fi
      }}

      %[ $LF_LEVEL -eq 1 ] || echo "Warning: You're in a nested lf instance!"
    '';

    commands = {
      open = "$set -f; ${pkgs.myPackages.rifle}/bin/rifle -p 0 $fx";
      paste = ''${"$"}${pkgs.myPackages.cp-p}/bin/cp-p --lf-paste $id'';
      trash = "${"$"}${pkgs.trash-cli}/bin/trash $fx";
      z = ''
        %{{
          # result="$(zoxide query --exclude $PWD $@)"
          result="$(zoxide query $@)"
          lf -remote "send $id cd $result"
        }}
      '';

      zi = ''
        ${"\${{"}
          result="$(zoxide query $@ -i)"
          lf -remote "send $id cd $result"
        }}
      '';

      git_pull = "\${{clear; git pull --rebase || true; echo \"press ENTER\"; read ENTER}}";
      git_status = "\${{clear; git status; echo \"press ENTER\"; read ENTER}}";
      git_log = "\${{clear; git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit}}";

      on-cd = ''
        &{{
          # display git repository status in your prompt
          source ${pkgs.git}/share/bash-completion/completions/git-prompt.sh
          GIT_PS1_SHOWDIRTYSTATE=auto
          GIT_PS1_SHOWSTASHSTATE=auto
          GIT_PS1_SHOWUNTRACKEDFILES=auto
          GIT_PS1_SHOWUPSTREAM=auto
          GIT_PS1_COMPRESSSPARSESTATE=auto
          git=$(__git_ps1 " [GIT BRANCH:> %s]") || true
          fmt="\033[32;1m%u@%h\033[0m:\033[34;1m%w\033[0m\033[33;1m$git\033[0m"
          lf -remote "send $id set promptfmt \"$fmt\""

          # set window title
          printf "\033]0; $(pwd | sed "s|$HOME|~|") - lf\007" > /dev/tty
        }}
      '';

      fzf_jump = ''
        ${"\${{"}
          res="$(find . -maxdepth 1 | fzf --reverse --header='Jump to location' | sed 's/\\/\\\\/g;s/"/\\"/g')"
          if [ -d "$res" ] ; then
            cmd="cd"
          elif [ -f "$res" ] ; then
            cmd="select"
          else
            exit 0
          fi
          lf -remote "send $id $cmd \"$res\""
        }}
      '';

      fzf_search = ''
        ${"\${{"}
        res="$( \
          RG_PREFIX="rg --column --line-number --no-heading --color=always \
            --smart-case "
          FZF_DEFAULT_COMMAND="$RG_PREFIX ${"''"}" \
            fzf --bind "change:reload:$RG_PREFIX {q} || true" \
            --ansi --layout=reverse --header 'Search in files' \
            | cut -d':' -f1
          )"
          [ ! -z "$res" ] && lf -remote "send $id select \"$res\""
        }}
      '';

      # mkdir command which joins spaces into one name
      mkdir = "%IFS=\" \"; mkdir -p -- \"$*\"";

      bulkrename = ''
        ${"\${{"}
          ${pkgs.vimv-rs}/bin/vimv --git -- $(basename -a -- $fx)

          lf -remote "send $id load"
          lf -remote "send $id unselect"
        }}
      '';

      select_files = ''
        ${"\${{"}
          { echo "$fs"; find -L "$(pwd)" -mindepth 1 -maxdepth 1 -type f; } |
            if [ "$lf_hidden" = "false" ]; then
              # remove any hidden files so you only select files you can see.
              grep -v '/\.[^/]\+$'
            else
              cat
            fi |
            sed '/^$/d' | sort | uniq -u |
            xargs -d '\n' -r -I{} lf -remote "send $id toggle {}"
        }}
      '';

      select_dirs = ''
        ${"\${{"}
          { echo "$fs"; find -L "$(pwd)" -mindepth 1 -maxdepth 1 -type d; } |
            if [ "$lf_hidden" = "false" ]; then
              grep -v '/\.[^/]\+$'
            else
              cat
            fi |
            sed '/^$/d' | sort | uniq -u |
            xargs -d '\n' -r -I{} lf -remote "send $id toggle {}"
        }}
      '';

      yank_dirname = "$dirname -- \"$f\" | head -c-1 | xclip -i -selection clipboard";
      yank_path = "$printf '%s' \"$fx\" | xclip -i -selection clipboard";
      yank_basename = "$basename -a -- $fx | head -c-1 | xclip -i -selection clipboard";
      yank_basename_without_extension = "&basename -a -- $fx | rev | cut -d. -f2- | rev | head -c-1 | xclip -i -selection clipboard";
    };

    keybindings = {
      gp = ":git_pull";
      gs = ":git_status";
      gl = ":git_log";
      "<c-f>" = ":fzf_jump";
      "<c-r>" = ":fzf_search";
      a = "push :mkdir<space>";
      "<c-z>" = "$ kill -STOP $PPID";
      "<c-j>" = ":half-down";
      "<c-k>" = ":half-up";
      "<enter>" = ":open";
      "<c-h>" = ":set hidden!";
    };
  };
}
