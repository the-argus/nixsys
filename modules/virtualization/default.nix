{ pkgs, config, lib, ... }:
let
  cfg = config.virtualization;
  inherit (lib) mkIf mkEnableOption mkOption;
in
{
  options.virtualization = {
    enable = mkEnableOption "Music Production Software";

    passthrough = {
      enable = mkEnableOption "Single GPU passthrough utilities for my hardware.";
    };
  };

  config = mkIf cfg.enable
    {
      environment.systemPackages = with pkgs; [
        qemu
        qemu_kvm
      ];
    } // mkIf cfg.passthrough.enable {
    # gpu passthrough stuff
    environment.systemPackages = with pkgs; [
      OVMFFull
    ];
  };
}
