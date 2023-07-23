{pkgs, ...}: {
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
      enable = false;
      nobar = false;
    };
    gnome.enable = false;
    labwc.enable = true;
    # plasma.enable = true;
    terminal = pkgs.kitty;
  };
}
