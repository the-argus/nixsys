{ pkgs, ... }:
pkgs.stdenv.mkDerivation {
  pname = "font-icons";
  version = "1.0";

  src = pkgs.fetchgit {
    url = "https://aur.archlinux.org/ttf-font-icons.git";
    rev = "3623e9da522da81e61bafdc469076812491eb33a";
    sha256 = "17byxlvzf1lwjqq1brkh9mhi4jvjr4zgm5sy11gpw75zv4pchfyv";
  };

  installPhase = ''
    mkdir -p $out/share/font/truetype
    cp icons.ttf $out/share/font/truetype/font-icons.ttf
  '';
}
