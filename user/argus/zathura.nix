{ pkgs, ... }: {
  home.file =
    let
      p = import ./color.nix { };
    in
    {
      ".config/zathura" = {
        text = ''
          set selection-clipboard clipboard
          set recolor                     "true"
          set recolor-keephue             "true"

          set default-bg                  "#${p.bg}"
          set default-fg                  "#${p.white}"

          set statusbar-fg                "#${p.white}"
          set statusbar-bg                "#${p.altbg3}"

          set inputbar-bg                 "#${p.black}"
          set inputbar-fg                 "#${p.cyan}"

          set notification-bg             "#${p.white}"
          set notification-fg             "#${p.altbg3}"

          set notification-error-bg       "#${p.yellow}"
          set notification-error-fg       "#${p.altbg3}"

          set notification-warning-bg     "#${p.cyan}"
          set notification-warning-fg     "#${p.altbg3}"

          set highlight-color             "#${p.cyan}"
          set highlight-active-color      "#${p.red}"

          set completion-bg               "#${p.black}"
          set completion-fg               "#${p.cyan}"

          set completion-highlight-fg     "#${p.altfg2}"
          set completion-highlight-bg     "#${p.cyan}"

          set recolor-lightcolor          "#${p.bg}"
          set recolor-darkcolor           "#${p.white}"
        '';
      };
    };
}
