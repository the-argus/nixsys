{ kanagawa-gtk, stdenv, gtk-engine-murrine, ... }:
{
  name = "Kanagawa-B";
  pkg = stdenv.mkDerivation rec {
    pname = "kanagawa";
    version = "0.1";

    src = kanagawa-gtk;

    propagatedUserEnvPkgs = [ gtk-engine-murrine ];

    installPhase = ''
      mkdir -p $out/share/themes/kanagawa
      cp -r themes/Kanagawa-B $out/share/themes
      cp -r themes/Kanagawa-BL $out/share/themes
    '';
  };
}
