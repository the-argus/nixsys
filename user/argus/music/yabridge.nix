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
      default = "";
      description = "An out-of-store path to append to yabridge configuration. Must be added to your DAW's VST search path.";
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

      # edit yabridge config to explicitly include extraPath
      escapedExtraPath = lib.strings.escape ["/"] cfg.extraPath;
      patch =
        if cfg.extraPath != "" then
          ''sed -i "3s/\]$/,'${escapedExtraPath}']/" $out/config/yabridgectl/config.toml''
        else "";

      scriptContents =
        ''
          mkdir $out
          export WINEPREFIX=$out/wine
          export XDG_CONFIG_HOME=$out/config
          export HOME=$out/home
          PATH=${cfg.package}/bin:$PATH
          ${cfg.ctlPackage}/bin/yabridgectl set --path=${cfg.package}/lib
          ${builtins.concatStringsSep "\n" commands}
          ${cfg.ctlPackage}/bin/yabridgectl sync

          ${patch}
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
