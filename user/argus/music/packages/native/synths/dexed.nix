{ pkgs, ... }:
pkgs.stdenv.mkDerivation {
  name = "dexed-synth";
  src = pkgs.fetchurl {
    url = "https://github.com/asb2m10/dexed/releases/download/v0.9.6/dexed-0.9.6-lnx.zip";
    sha256 = "0cwqpm8n8jwcrd09nsbl2cz2rz3hwr29dsir2bwlibxsjxl5zk6b";
  };

  nativeBuildInputs = [ pkgs.unzip ];

  installPhase = "cp -r . $out";
}
