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
  options.virtualization.containers.docker.enable = mkOption {
    description = "Enable docker and its daemon";
    type = types.bool;
    default = true;
  };

  config = mkIf (config.virtualization.containers.docker.enable
    && config.virtualization.containers.enable) {
    virtualisation.docker.enable = true;
    users.users.${username}.extraGroups = ["docker"];
  };
}
