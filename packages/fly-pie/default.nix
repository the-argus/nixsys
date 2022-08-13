{ stdenv
, lib
, fetchFromGitHub
, gitUpdater
, gettext
, glib
, zip
, unzip
}:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-fly-pie";
  version = "16";

  src = fetchFromGitHub {
    owner = "Schneegans";
    repo = "Fly-Pie";
    rev = "v${version}";
    sha256 = "15ixjn962910jx3jnjmbx2lxb5wvv1l1az00rba3s2vbcd7fiwh7";
  };

  nativeBuildInputs = [
    gettext glib zip unzip
  ];

  dontPatch = false;
  patches = [ ./0001-shell-patch.patch ./0001-remove-install-phase.patch ];

  installPhase = ''
    ls .
    INSTALLDIR=$out/share/gnome-shell/extensions/flypie@schneegans.github.com
    mkdir -p $INSTALLDIR
    unzip "flypie@schneegans.github.com.zip" -d $INSTALLDIR
  '';

  passthru = {
    extensionUuid = "flypie@schneegans.github.com";
    extensionPortalSlug = "fly-pie";

    updateScript = gitUpdater {
      pname = "gnomeExtensions.fly-pie";
      inherit version;
      rev-prefix = "v";
    };
  };
}
