{ lib, pkgs, picom, config, ... }:
let
  cfg = config.packages.picom;
  inherit (lib) mkIf mkEnableOption mkOption;
in
{
  options.packages.picom = {
    enable = mkEnableOption "Custom Packages";

    package = mkOption {
        #type = lib.types.derivation;
        default = pkgs.picom;
        description = "do not use";
    };
  };


  config = mkIf cfg.enable {
    package = pkgs.stdenv.mkDerivation
      rec {
        pname = "picom-fork";
        version = "9.1";

        src = picom;

        buildInputs = with pkgs; [
          ninja
          meson
          libev
          pkgconfig
          xorg.libX11
          xorg.xcbutilrenderutil
          xorg.xcbutilimage
          xorg.libXext
          xorg.pixman
          uthash
          libconfig
          pcre
          libGL
          dbus
        ];

        buildPhase = ''
          meson --buildtype=release . build
          ninja -C build
        '';

        installPhase = ''
          cp build/src/picom $out/bin/picom
        '';
      };
  };
}
