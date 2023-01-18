{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.keyboard.dvorak;
in {
  options.keyboard.dvorak = {
    enable = mkEnableOption "Use the dvorak layout in the console and add the layout to Xorg.";
  };
  config = mkIf cfg.enable {
    console.keyMap = "dvorak-programmer";
    services = {
      xserver = {
        layout = "us,us";
        xkbVariant = ",dvp";
        xkbOptions = "compose:ralt,caps:ctrl_modifier,grp_led:caps";
      };
    };
  };
}
