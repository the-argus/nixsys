{
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  gtk3-x11,
  gtk-layer-shell,
  pulseaudio,
  ...
}:
rustPlatform.buildRustPackage rec {
  pname = "sway-osd";
  version = "2023-05-19";

  src = fetchFromGitHub {
    owner = "ErikReider";
    repo = "SwayOSD";
    rev = "5c2176ae6a01a18fdc2b0f5d5f593737b5765914";
    sha256 = "sha256-rh42J6LWgNPOWYLaIwocU1JtQnA5P1jocN3ywVOfYoc=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    gtk3-x11
    gtk-layer-shell
    pulseaudio
  ];

  cargoSha256 = "sha256-H7x7Cc0jTa9i3fGw0ERUgkxlPL8eTxQ3j+B3igj8dZE=";
}
