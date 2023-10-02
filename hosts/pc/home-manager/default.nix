{pkgs, ...}: {
  imports = [];
  programs.yabridge.enable = true;

  home.packages = with pkgs; [
    kdenlive
    myPackages.IDEA
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
  ];
}
