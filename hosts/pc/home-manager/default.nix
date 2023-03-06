{
  config,
  pkgs,
  ...
}: {
  imports = [];
  programs.yabridge.enable = true;

  home.packages = with pkgs; [
    steam
    jre8
    aseprite
    zoom-us
    ferium
    protontricks
    filezilla
  ];
}
