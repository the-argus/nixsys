{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.programs.yabridge;
in
{
  options.programs.yabridge = {
    enable = mkEnableOption "Yabridge VST Emulation";

    paths = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Paths to folders which contain .vst and .vst3 plugins.";
    };

    extraPath = mkOption {
      type = types.str;
      default = "${config.home.homeDirectory}/.wine/drive_c/Program Files";
      description = "An out-of-store path to append to yabridge configuration.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.yabridge;
      description = "Nix package containing the yabridge binary.";
    };
    ctlPackage = mkOption {
      type = types.package;
      default = pkgs.yabridgectl;
      description = "Nix package containing the yabridgectl binary.";
    };
  };

  config =
    let
      yabridge = cfg.package;
      yabridgectl = cfg.ctlPackage;
      toCommand = path: "${cfg.ctlPackage}/bin/yabridgectl add ${path}";
      commands = map toCommand cfg.paths;

      scriptContents =
        ''
          mkdir $out
          export WINEPREFIX=$out/wine
          export XDG_CONFIG_HOME=$out/config
          export HOME=$out/home
          PATH=${cfg.package}/bin:$PATH
          echo $PATH
          ${cfg.ctlPackage}/bin/yabridgectl set --path=${cfg.package}/lib
          ${builtins.concatStringsSep "\n" commands}
          ${cfg.ctlPackage}/bin/yabridgectl sync

          # edit yabridge config to explicitly include extraPath
          sed -i "3s/\]$/,'${cfg.extraPath}']/" $out/config/yabridgectl/config.toml
        '';

      tracer = builtins.trace scriptContents scriptContents;

      userYabridge = pkgs.runCommandLocal "yabridge-configuration" { } tracer;
    in
    mkIf cfg.enable {
      home.packages = [ userYabridge yabridge yabridgectl ];
      home.file = {
        ".vst3" = {
          source = "${userYabridge}/home/.vst3";
          recursive = true;
        };

        ".config/yabridgectl" = {
          source = "${userYabridge}/config/yabridgectl";
          recursive = true;
        };
      };
    };
}
