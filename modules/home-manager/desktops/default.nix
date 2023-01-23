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
  ];

  options.desktops = {
    enable = mkEnableOption "Desktop";
    terminal = mkOption {
      type = types.package;
      default = pkgs.kitty;
    };
  };

  config =
    mkIf cfg.enable {};
}
