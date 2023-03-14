{
  buildGoModule,
  fetchFromGitHub,
  lib,
  libX11,
  pam,
  stdenv,
  noX11 ? false,
}:
buildGoModule rec {
  pname = "emptty";
  version = "0.9.1";
  
  src = fetchFromGitHub {
    owner = "tvrzna";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-CbTPJgnKMWMXdG6Hr8xT9ae4Q9MxAfhITn5WSCzCmI4=";
  };

  buildInputs = [pam] ++ (lib.lists.optionals (!noX11) [libX11]);

  vendorHash = "sha256-tviPb05puHvBdDkSsRrBExUVxQy+DzmkjB+W9W2CG4M=";

  tags = lib.lists.optionals noX11 ["noxlib"];

  prePatch = ''
    sed -i "s|/usr/share/xsessions/|/run/current-system/sw/share/xsessions|g" src/desktop.go
    sed -i "s|/usr/share/wayland-sessions/|/run/current-system/sw/share/wayland-sessions|g" src/desktop.go
  '';

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
