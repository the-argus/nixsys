{ pkgs, prefix, ... }:
pkgs.stdenv.mkDerivation {
  name = "WinePrefix";
  src = "${prefix}/drive_c/yabridge";
  
  unpackPhase = '''';
  installPhase = ''
    cp -r . $out
  '';
}
