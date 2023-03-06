{config, ...}: {
  home.file = with config.banner.palette; {
    ".config/zathura/zathurarc" = {
      text = ''
        set selection-clipboard clipboard
        set recolor                     "true"
        set recolor-keephue             "true"
        set smooth-scroll               "true"

        set default-bg                  "#${base00}"
        set default-fg                  "#${base05}"

        set statusbar-fg                "#${base05}"
        set statusbar-bg                "#${base03}"

        set inputbar-bg                 "#${base04}"
        set inputbar-fg                 "#${base0B}"

        set notification-bg             "#${base05}"
        set notification-fg             "#${base03}"

        set notification-error-bg       "#${urgent}"
        set notification-error-fg       "#${base00}"

        set notification-warning-bg     "#${warn}"
        set notification-warning-fg     "#${base00}"

        set highlight-color             "#${base02}"
        set highlight-active-color      "#${urgent}"

        set completion-bg               "#${base04}"
        set completion-fg               "#${base0B}"

        set completion-highlight-bg     "#${base0B}"
        set completion-highlight-fg     "#${base00}"

        set recolor-lightcolor          "#${base00}"
        set recolor-darkcolor           "#${base05}"
      '';
    };
  };
}
