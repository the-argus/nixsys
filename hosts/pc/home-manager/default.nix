{pkgs, ...}: {
  imports = [];
  programs.yabridge.enable = true;

  home.packages = with pkgs; [
    jetbrains.idea-community
    xorg_sys_opengl
    blender
    steam
    jre8
    aseprite
    zoom-us
    ferium
    protontricks
    filezilla
  ];
}
