{
  pkgs,
  config,
  inputs,
  lib,
  ...
}: let
  cfg = config.desktops;
  inherit (lib) mkIf mkEnableOption;
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
  };

  config =
    mkIf cfg.enable {
    };
}
