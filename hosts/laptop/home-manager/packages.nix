{pkgs, ...}: {
  home.packages = with pkgs; [
    musescore
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
