{
  pkgs,
  # kdab-viewer,
  kdab-flake,
  ...
}: {
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
    eww-wayland
    # blender
    arandr
    iio-sensor-proxy

    rocketchat-desktop

    ifuse
    # kdab-viewer.packages.${system}.default
    kdab-flake.packages.${system}.software.charm
  ];
}
