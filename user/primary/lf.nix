{pkgs, ...}: {
  home.packages = with pkgs; [
    # for pdftotext
    poppler_utils
    # for highlighting source text
    highlight
  ];
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
      source = pkgs.writeShellScript "lf-previewer.sh" ''
        # kitty previews
        if [[ "$( ${pkgs.file}/bin/file -Lb --mime-type "$1")" =~ ^image ]]; then
          file=$1
          w=$2
          h=$3
          x=$4
          y=$5
          kitty +icat --silent --transfer-mode file --place "${"\${w}x\${h}@\${x}x\${y}"}" "$file"
          exit 0
        fi
        case "$1" in
          *.tar*) tar tf "$1";;
          *.zip) unzip -l "$1";;
          *.rar) unrar l "$1";;
          *.7z) 7z l "$1";;
          *.pdf) pdftotext "$1" -;;
          *.md) glow "$1";;
          *) highlight -O ansi "$1";;
        esac
      '';
      keybinding = "i";
    };
  };
}
