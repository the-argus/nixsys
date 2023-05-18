{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktops;
  inherit (lib) mkIf mkEnableOption mkOption;
in {
  imports = [
    ./sway.nix
    ./qtile
    ./gnome.nix
    ./i3gaps.nix
    ./awesome.nix
    ./ratpoison.nix
    ./plasma.nix
    ./labwc.nix
  ];

  options.desktops = {
    enable = mkEnableOption "Desktop";
    terminal = mkOption {
      type = lib.types.package;
      default = pkgs.kitty;
    };
  };

  config =
    mkIf cfg.enable {};
}
