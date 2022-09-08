{ stdenv, fetchgit, gtk-engine-murrine, ... }:
stdenv.mkDerivation rec {
  pname = "rose-pine-gtk";
  version = "1.0";

  src = fetchgit {
    url = "https://github.com/rose-pine/gtk";
    sha256 = "0zdk0yig1jj5gvk4b7m254mk5nimm553wl5bpdddqnvpira56gz5";
    rev = "af7897d54d8ce9f127ab7282d1aa862386dc8271";
  };

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  installPhase = ''
    mkdir -p $out/share/themes/rose-pine-gtk
    mkdir -p $out/share/icons/rose-pine-icons
    cp -r gtk3/rose-pine-gtk $out/share/themes
    cp -r gtk4 $out/share/themes/rose-pine-gtk
    cp -r icons/rose-pine-icons $out/share/icons
  '';
}
