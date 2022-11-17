{
  pkgs,
  unstable,
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.gaming;
in {
  options.gaming = {
    enable = mkEnableOption "Install game launchers and setup hardware.";
    minecraft = mkEnableOption "Install a minecraft launcher, pretty much.";
    steam = mkEnableOption "Enable steam and the hardware changes necessary for it.";
  };

  config = mkIf cfg.enable {
    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "steam"
        "steam-original"
      ];
    home.packages = with pkgs;
      [
        heroic
        # lutris
      ]
      ++ (lib.lists.optionals cfg.minecraft (with pkgs; [
        prismlauncher
        unstable.ferium
        jre8
      ]))
      ++ (lib.lists.optionals cfg.steam (with pkgs; [
        steam
        protontricks
      ]));
  };
}
