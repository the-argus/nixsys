{pkgs, ...}: {
  home.packages = with pkgs; [
    # musescore
    # libreoffice-fresh
    # krita
    # cage
    # itd
    # screen
    # fbterm
    # obsidian
    # eww-wayland
    # blender
    godot_4
    arandr
    iio-sensor-proxy
    aseprite
    # distrobox
    ifuse
  ];
}
