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
  };
}
