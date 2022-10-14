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
  options.virtualization.containers = mkOption {
    type = types.submodule {
      options = {
        docker = mkEnableOption "Enable docker and its daemon";
        podman = mkEnableOption "Enable podman";
      };
    };
    default = {
      docker = false;
      podman = false;
    };
  };

  config =
    mkIf config.virtualization.containers.docker.enable {
      virtualisation.docker.enable = true;
      users.users.${username}.extraGroups = ["docker"];
    }
    // (mkIf config.virtualization.containers.podman.enable {
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
    });
}
