{ pkgs, prefix, ... }:
pkgs.stdenv.mkDerivation {
  name = "WinePrefix";
  src = "${prefix}/drive_c/Program Files";

  installPhase = ''
    cp -r . $out
  '';
}
