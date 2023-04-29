{pkgs, ...}: {
  imports = [];
  programs.yabridge.enable = true;

  home.packages = with pkgs; [
    jetbrains.idea-community
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
