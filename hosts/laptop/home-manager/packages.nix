{pkgs, ...}: {
  home.packages = with pkgs; [
    reaper
    # musescore
    # libreoffice-fresh
    # aseprite-unfree
    # krita
    # cage
    # itd
    # screen
    # fbterm
    # obsidian
    # eww-wayland
    # blender
    arandr
    iio-sensor-proxy
    # distrobox
    ifuse
  ];
}
