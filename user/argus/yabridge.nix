{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.programs.yabridge;
in
{
  options.programs.yabridge = {
    enable = mkEnableOption "Yabridge VST Emulation";

    paths = mkOption {
      type = types.list;
      default = [ ];
      description = "Paths to folders which contain .vst and .vst3 plugins.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.yabridge;
      description = "Nix package containing the yabridge binary.";
    };
    ctlPackage = mkOption {
      type = types.package;
      default = pkgs.yabridge;
      description = "Nix package containing the yabridgectl binary.";
    };
  };

  config = mkIf cfg.enable {
    home.packages =
      let
        yabridge = cfg.package;

        toCommand = path: "${cfg.ctlPackage}/bin/yabridgectl add ${path}\n";
        commands = map toCommand cfg.paths;

        custom-yabridgectl = cfg.ctlPackage.overrideAttrs (oldAttrs: rec {
          postInstall = ''
            ${commands}
            ${cfg.ctlPackage}/bin/yabridgectl sync
          '';
        });
      in
      [ custom-yabridgectl yabridge ];
  };
}
