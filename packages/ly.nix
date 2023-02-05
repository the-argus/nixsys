{
  stdenv,
  lib,
  fetchFromGitHub,
  linux-pam,
}:
stdenv.mkDerivation rec {
  pname = "ly";
  version = "unstable-2022-07-16";

  src = fetchFromGitHub {
    owner = "fairyglade";
    repo = "ly";
    rev = "b5d3ef0a7034407b746b6193c464bb9c497eb54b";
    sha256 = "sha256-orCqjKlK6U1q7NDoMwxZZE44cyG8yuxdCCk1cQAalP0=";
    fetchSubmodules = true;
  };

  buildInputs = [linux-pam];
  makeFlags = ["FLAGS=-Wno-error"];

  installPhase = ''
    mkdir -p $out/bin
    cp bin/ly $out/bin
  '';

  meta = with lib; {
    description = "TUI display manager";
    license = licenses.wtfpl;
    homepage = "https://github.com/cylgom/ly";
    maintainers = [maintainers.vidister];
  };
}
