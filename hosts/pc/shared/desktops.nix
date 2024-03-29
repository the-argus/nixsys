{pkgs, ...}: {
  desktops = {
    enable = true;
    sway.enable = true;
    # awesome.enable = true;
    # ratpoison.enable = true;
    qtile.enable = true;
    i3gaps.enable = false;
    gnome.enable = true;
    labwc.enable = false;
    # plasma.enable = true;
    terminal = pkgs.kitty;
  };
}
