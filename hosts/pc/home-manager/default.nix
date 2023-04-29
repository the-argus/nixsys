{pkgs, ...}: {
  imports = [];
  programs.yabridge.enable = true;

  home.packages = with pkgs; [
    myPackages.IDEA
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
