{
  lib,
  options,
  config,
  username,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
in {
  options.virtualization.containers.docker.enable =
    mkEnableOption
    "Install docker and enable its daemon";

  config = mkIf (config.virtualization.containers.docker.enable && (!config.system.minimal)) {
    virtualisation.docker.enable = true;
    users.users.${username}.extraGroups = ["docker"];
  };
}
