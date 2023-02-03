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
    godot_4
    zoom-us
    ferium
    protontricks
  ];
}
