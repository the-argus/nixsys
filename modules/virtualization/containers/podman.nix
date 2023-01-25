{
  pkgs,
  lib,
  options,
  config,
  username,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
in {
  options.virtualization.containers.podman.enable =
    mkEnableOption
    "Enable podman";

  config = mkIf (config.virtualization.containers.podman.enable && (!config.system.minimal)) {
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
