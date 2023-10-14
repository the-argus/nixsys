{
  pkgs,
  kdab-flake,
  ...
}: {
  imports = [];
  programs.yabridge.enable = true;

  home.packages = with pkgs; [
    kdenlive
    myPackages.IDEA
    # jetbrains.rider
    myPackages.hansoft
    blender
    steam
    jre8
    aseprite
    zoom-us
    protontricks
    blender
    pulseeffects-pw

    rocketchat-desktop
    kdab-flake.packages.${system}.software.charm
  ];
}
