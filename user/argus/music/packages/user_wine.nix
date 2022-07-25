{ pkgs, prefix, ... }:
pkgs.stdenv.mkDerivation {
  name = "WinePrefix";
  src = /. + "${prefix}/drive_c/yabridge";
  
  dontUnpack = true;
  installPhase = ''
    cp -r . $out
  '';
}
