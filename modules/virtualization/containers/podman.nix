{
  pkgs,
  lib,
  options,
  config,
  username,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption types;
in {
  # options.virtualization.containers.podman.enable = mkOption {
  #   description = "Enable podman";
  #   type = types.bool;
  #   default = true;
  # };
  options.virtualization.containers.podman.enable =
    mkEnableOption
    "Enable podman";

  config = mkIf (config.virtualization.containers.podman.enable
    && config.virtualization.containers.enable) {
    users.extraUsers.${username} = {
      subUidRanges = [
        {
          startUid = 100000;
          count = 65536;
        }
      ];
      subGidRanges = [
        {
          startGid = 100000;
          count = 65536;
        }
      ];
    };
    virtualisation.podman = {
      enable = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.dnsname.enable = true;

      extraPackages = [pkgs.podman-compose];
    };
  };
}
