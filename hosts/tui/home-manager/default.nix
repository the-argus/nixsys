{pkgs, ...}: {
  home.packages = with pkgs; [
    itd
    screen
  ];
  programs.yabridge.enable = false;
  system.minimal = true;
}
