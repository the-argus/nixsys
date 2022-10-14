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
  imports = [./podman.nix ./docker.nix];

  options.virtualization.containers =
    mkEnableOption
    "Set up container software such as podman and docker";
}
