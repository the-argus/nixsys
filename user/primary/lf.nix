{pkgs, ...}: let
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
  programs.lf = {
    enable = true;
    settings = {
      drawbox = true;
      dirfirst = true;
      icons = true;
      ignorecase = true;
      preview = true;
      shell = "sh";
      shellopts = "-eu";
      tabstop = 2;
    };
    previewer = {
      source = sandbox;
      keybinding = "i";
    };
    extraConfig = ''
      set cleaner ${cleaner}
    '';

    commands = {
      paste = ''$cp-p --lf-paste $id'';
      z = ''
        result="$(zoxide query --exclude $PWD $@)"
        lf -remote "send $id cd $result"
      '';

      zi = ''
        result="$(zoxide query -i)"
        lf -remote "send $id cd $result"
      '';

      git_pull = ''clear; git pull --rebase || true; echo "press ENTER"; read ENTER'';
      git_status = ''clear; git status; echo "press ENTER"; read ENTER'';
      git_log = ''clear; git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit'';

      on-cd = ''
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
      '';
    };

    keybindings = {
      gp = "git_pull";
      gs = "git_status";
      gl = "git_log";
    };
  };
}
