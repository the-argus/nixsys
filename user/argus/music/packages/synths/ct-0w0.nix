{ pkgs, ... }:
pkgs.stdenv.mkDerivation {
  name = "CT-0W0";
  src = pkgs.fetchurl {
    url = "https://heckscaper.com/plugins/cb/ct0w0_vst364_20220610.zip";
    sha256 = "138rj86gbp7dc4iavc880nhvylhy6m6srjpnnbx1i2lknd54islj";
  };

  nativeBuildInputs = [ pkgs.unzip ];

  installPhase = "cp -r . $out";
}
