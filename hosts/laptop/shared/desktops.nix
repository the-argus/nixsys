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
      enable = true;
      nobar = false;
    };
    gnome.enable = false;
    labwc.enable = false;
    # plasma.enable = true;
    terminal = pkgs.kitty;
  };
}
