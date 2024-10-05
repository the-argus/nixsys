{pkgs, nixpkgs-master, ...}: {
  home.packages = with pkgs; [
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
    (import nixpkgs-master { localSystem = pkgs.system; }).godot_4
    arandr
    iio-sensor-proxy
    # distrobox
    ifuse
  ];
}
