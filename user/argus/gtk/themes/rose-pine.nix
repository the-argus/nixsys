{ rose-pine-gtk, stdenv, gtk-engine-murrine, ... }:
{
  name = "rose-pine-gtk";
  iconName = "rose-pine-icons";
  pkg = stdenv.mkDerivation rec {
    pname = "rose-pine-gtk";
    version = "1.0";

    src = rose-pine-gtk;

    propagatedUserEnvPkgs = [ gtk-engine-murrine ];

    installPhase = ''
      mkdir -p $out/share/themes/rose-pine-gtk
      mkdir -p $out/share/icons/rose-pine-icons
      cp -r gtk3/rose-pine-gtk $out/share/themes
      cp -r gtk4 $out/share/themes/rose-pine-gtk
      cp -r icons/rose-pine-icons $out/share/icons
    '';
  };
}
