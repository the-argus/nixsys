{pkgs, ...}: {
  desktops = {
    enable = true;
    sway.enable = true;
    # awesome.enable = true;
    # ratpoison.enable = true;
    qtile.enable = true;
    i3gaps.enable = true;
    gnome.enable = true;
    # plasma.enable = true;
    terminal = pkgs.kitty;
  };
}
