{
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  gettext,
  glib,
  zip,
  unzip,
}:
stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-fly-pie";
  version = "18";

  src = fetchFromGitHub {
    owner = "Schneegans";
    repo = "Fly-Pie";
    rev = "v${version}";
    sha256 = "sha256-2dHdY/X4cm6zIys35Knc9g6+k15q9ykChqhAtvs9Aok=";
  };

  nativeBuildInputs = [
    gettext
    glib
    zip
    unzip
  ];

  dontPatch = false;
  patches = [./0001-remove-install-phase.patch];

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
