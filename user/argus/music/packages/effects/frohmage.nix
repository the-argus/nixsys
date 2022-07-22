{ pkgs, ... }:
pkgs.stdenv.mkDerivation {
  name = "Frohmage";
  src = pkgs.fetchurl {
    url = "https://freevstplugins.net/wp-content/uploads/get-it/Frohmage-160_x64.zip";
    sha256 = "0igz28vxj21mgfsk0pvy7wmc4fk233anjx3zw6w620qyjv7gydbz";
  };

  nativeBuildInputs = [ pkgs.unzip pkgs.winePackages.minimal ];

  installPhase = ''
    wine ./Frohmage-160-win64-vst-free.exe
  '';
}
