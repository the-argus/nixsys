{
  fetchFromGitHub,
  rustPlatform,
  ...
}:
rustPlatform.buildRustPackage rec {
  pname = "sudo-askpass";
  version = "v1.1.0";

  src = fetchFromGitHub {
    owner = "Absolpega";
    repo = "simple-terminal-sudo-askpass";
    rev = version;
    sha256 = "sha256-pYlMEiVtBaApInkFtDz5tnhRiMnIq6YLY8tZb83gCig=";
  };

  cargoSha256 = "sha256-tknAH0u+abVIshXxDkHxbzOfDkpL3gwCdiopdsIADtQ=";

  prePatch = ''
    sed -i "s/use std::os::fd::AsRawFd;/use std::os::unix::io::AsRawFd;/g" src/main.rs
  '';
}
