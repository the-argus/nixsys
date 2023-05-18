{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.desktops.labwc;
  inherit (lib) mkEnableOption mkIf literalExpression mkOption types;
in {
  options.desktops.labwc = {
    enable = mkEnableOption "Labwc Window Manager";
    enableXWayland = mkOption {
      type = types.bool;
      default = true;
      description = "XWayland support";
    };
    package = mkOption {
      type = types.package;
      default = pkgs.labwc;
      defaultText = literalExpression "pkgs.labwc";
      description = "The package containing /bin/labwc and correct, override-able options to invoke when launching the window manager.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      myPackages.wlrctl # cool scripting stuff I hear
    ];
  };
}
