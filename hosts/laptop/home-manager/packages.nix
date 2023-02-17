{pkgs, ...}: {
  home.packages = with pkgs; [
    # libreoffice-fresh
    # aseprite-unfree
    # krita
    cool-retro-term
    # cage
    itd
    # screen
    # fbterm
    virt-viewer
    # obsidian
    eww
    # blender
    arandr
    iio-sensor-proxy

    ifuse
  ];
}
