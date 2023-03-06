{...}: {
  desktops = {
    enable = true;
    sway = {
      enable = true;
      nobar = false;
    };
    awesome.enable = false;
    ratpoison.enable = false;
    qtile.enable = true;
    i3gaps = {
      enable = true;
      nobar = true;
    };
    gnome.enable = true;
    # plasma.enable = true;
  };
}
