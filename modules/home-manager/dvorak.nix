{lib, ...}: let
  inherit (lib) mkEnableOption;
in {
  options.keyboard.dvorak = {
    enable = mkEnableOption "Use the dvorak layout in the console and add the layout to Xorg.";
  };
}
