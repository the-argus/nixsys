{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.music;
  inherit (lib) mkIf mkEnableOption;
in {
  options.music.enable = mkEnableOption "Music Production Software";

  config = mkIf (cfg.enable && !config.system.minimal) {
    environment.systemPackages = with pkgs; [
      # vst emulation
      # wineWowPackages.full
      # winetricks
      # (import ../../packages/carla.nix {inherit pkgs;})
      # carla
      # airwave is unfortunately out of date
      #(import ../../packages/airwave.nix {inherit pkgs; inherit lib;})
    ];

    # boot.kernelModules = [ "snd-seq" "snd-rawmidi" ];

    # low latency setup
    services.pipewire = {
      # jack.enable = true;
      # config = {
      #   pipewire = {
      #     "context.properties" = {
      #       "link.max-buffers" = 64;
      #       #   "link.max-buffers" = 16; # version < 3 clients can't handle more than this
      #       "log.level" = 2; # https://docs.pipewire.org/page_daemon.html
      #       "default.clock.rate" = 48000;
      #       "default.clock.quantum" = 32; # adjust this lower if there are no crackles, higher if there are
      #       "default.clock.min-quantum" = 32;
      #       "default.clock.max-quantum" = 32;
      #       "core.daemon" = true;
      #       "core.name" = "pipewire-0";
      #     };
      #     "context.modules" = [
      #       {
      #         name = "libpipewire-module-rtkit";
      #         args = {
      #           "nice.level" = -15;
      #           "rt.prio" = 88;
      #           "rt.time.soft" = 200000;
      #           "rt.time.hard" = 200000;
      #         };
      #         flags = [ "ifexists" "nofail" ];
      #       }
      #       { name = "libpipewire-module-protocol-native"; }
      #       { name = "libpipewire-module-profiler"; }
      #       { name = "libpipewire-module-metadata"; }
      #       { name = "libpipewire-module-spa-device-factory"; }
      #       { name = "libpipewire-module-spa-node-factory"; }
      #       { name = "libpipewire-module-client-node"; }
      #       { name = "libpipewire-module-client-device"; }
      #       {
      #         name = "libpipewire-module-portal";
      #         flags = [ "ifexists" "nofail" ];
      #       }
      #       {
      #         name = "libpipewire-module-access";
      #         args = { };
      #       }
      #       { name = "libpipewire-module-adapter"; }
      #       { name = "libpipewire-module-link-factory"; }
      #       { name = "libpipewire-module-session-manager"; }
      #     ];
      #   };
      #
      #   # separate config for pulseaudio backend
      #   # do not make the quantum values lower in PA than in PW
      #   pipewire-pulse = {
      #     # "context.exec" = [
      #     #   {
      #     #     args = "load-module module-always-sink";
      #     #     path = "${pkgs.pulseaudio}/bin/pactl";
      #     #   }
      #     # ];
      #     "pulse.rules" = [
      #       {
      #         matches = [
      #           { "application.process.binary" = "Discord"; }
      #           { "application.process.binary" = "firefox"; }
      #         ];
      #         actions = {
      #           update-props = { "pulse.min.quantum" = "1024/48000"; };
      #         };
      #       }
      #     ];
      #     "context.properties" = {
      #       "log.level" = 2;
      #     };
      #     "context.modules" = [
      #       {
      #         name = "libpipewire-module-rtkit";
      #         args = {
      #           "nice.level" = -15;
      #           "rt.prio" = 88;
      #           "rt.time.soft" = 200000;
      #           "rt.time.hard" = 200000;
      #         };
      #         flags = [ "ifexists" "nofail" ];
      #       }
      #       { name = "libpipewire-module-protocol-native"; }
      #       { name = "libpipewire-module-client-node"; }
      #       { name = "libpipewire-module-adapter"; }
      #       { name = "libpipewire-module-metadata"; }
      #       {
      #         name = "libpipewire-module-protocol-pulse";
      #         args = {
      #           "pulse.min.req" = "32/48000";
      #           "pulse.default.req" = "32/48000";
      #           "pulse.max.req" = "32/48000";
      #           "pulse.min.quantum" = "32/48000";
      #           "pulse.max.quantum" = "32/48000";
      #           "server.address" = [ "unix:native" ];
      #         };
      #       }
      #     ];
      #     "stream.properties" = {
      #       "node.latency" = "32/48000";
      #       "resample.quality" = 1;
      #     };
      #   };
      # };
    };
  };
}
