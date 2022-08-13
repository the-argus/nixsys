{ stdenv
, lib
, fetchFromGitHub
, gitUpdater
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

  dontPatch = false;
  patches = [ ./0001-shell-patch.patch ];

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
