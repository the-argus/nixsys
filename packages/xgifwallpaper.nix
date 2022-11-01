{
  rustPlatform,
  fetchgit,
  xorg,
  ...
}:
rustPlatform.buildRustPackage rec {
  pname = "xgifwallpaper";
  version = "0.3.2-dev";
  src = fetchgit {
    url = "https://github.com/calculon102/xgifwallpaper";
    rev = "854293c0f04736eed086bca8124b3e3210537de2";
    sha256 = "0fx2ap4w9dk8hkpr26d7sfvhi8ry57343i6fhqll11r1181m9iyk";
  };

  buildInputs = with xorg; [
    libX11
    libxcb
    libXext
    libXinerama
  ];

  cargoSha256 = "sha256-6sl07xSORueshoPTETj8KZa1i9HVQ/ERatbpO92w040=";

  installPhase = ''
    mkdir -p $out/bin
    cp target/x86_64-unknown-linux-gnu/release/xgifwallpaper $out/bin/
  '';
}
