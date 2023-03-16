{
  buildGoModule,
  fetchFromGitHub,
  lib,
  libX11,
  pam,
  stdenv,
  wayland,
  noX11 ? false,
}:
buildGoModule rec {
  pname = "emptty";
  version = "0.9.1";
  
  src = fetchFromGitHub {
    owner = "tvrzna";
    repo = pname;
    rev = "9d2be5e6b101593f42a561418d15fa68562d4b6e";
    sha256 = "1zm703yw9y4ma508hscbry5ml1xz0lwqpk4rfn8vx7gadnjs56gr";
  };

  buildInputs = [wayland pam] ++ (lib.lists.optionals (!noX11) [libX11]);

  vendorHash = "sha256-tviPb05puHvBdDkSsRrBExUVxQy+DzmkjB+W9W2CG4M=";

  tags = lib.lists.optionals noX11 ["noxlib"];

  buildPhase = ''
    runHook preBuild
    make build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    make DESTDIR=$out install
    make DESTDIR=$out install-manual
    # make DESTDIR=$out install-systemd

    if [ -d $out/usr ]; then
      mv $out/usr/* $out
      rmdir $out/usr
    fi

    runHook postInstall
  '';

  meta = with lib; {
    description = "Dead simple CLI Display Manager on TTY";
    homepage = "https://github.com/tvrzna/emptty";
    license = licenses.mit;
    maintainers = with maintainers; [urandom];
    # many undefined functions
    broken = stdenv.isDarwin;
  };
}
