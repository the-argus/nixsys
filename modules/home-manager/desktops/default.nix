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

  # just for compatibility with the nixos module, ATM there is no configuration
  # for hevel it is just patches, so home-manager has nothing to do
  options.programs.hevel.enable = mkEnableOption "Hevel";

  options.desktops = {
    enable = mkEnableOption "Desktop";
    terminal = mkOption {
      type = lib.types.package;
      default = pkgs.kitty;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      dunst
    ];
  };
}
