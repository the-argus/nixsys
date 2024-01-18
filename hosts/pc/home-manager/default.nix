{
  pkgs,
  kdab-flake,
  ...
}: {
  imports = [];
  programs.yabridge.enable = true;

  home.packages = with pkgs; [
    # kdenlive
    myPackages.IDEA
    # jetbrains.rider
    # myPackages.hansoft
    # blender
    (gimp-with-plugins.override {plugins = with pkgs.gimpPlugins; [gmic];})
    inkscape
    steam
    jre8
    aseprite
    zoom-us
    protontricks
    xournalpp

    rocketchat-desktop
    kdab-flake.packages.${system}.software.charm
  ];
}
