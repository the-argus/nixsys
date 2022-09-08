{ pkgs, lib, stdenv, fetchgit, gtk-engine-murrine }:
stdenv.mkDerivation rec {
  pname = "nordic-icons";
  version = "2.2.0";

  # this is a cool custom set of icons, but very incomplete
  # src = fetchurl {
  #   url = "https://github.com/alvatip/Nordzy-icon/releases/download/1.6/Nordzy.tar.gz";
  #   sha256 = "0jw5bc12cg4qghi8v7dqz8bmg3lplzkvnyrjln1xamnfw2p1f6cj";
  # };
  src = fetchgit {
    url = "https://github.com/robertovernina/NordArc";
    sha256 = "0v151dp6lr5zm50v92qa2k9jl4346b9i6wjxm7zxh65g2m5c2nzf";
    rev = "441a64dea85a681cd38aa0685ba4fcac72adbd90";
  };
  sourceRoot = ".";

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  installPhase =
    let
      cursorSrc = builtins.fetchTarball {
        url = "https://github.com/alvatip/Nordzy-cursors/releases/download/v0.6.0/Nordzy-cursors.tar.gz";
        sha256 = "sha256:1lbl22z3cxb3yj86j6aqpfvjpih8zfg7vjnkawv1wwdg54y5cxaf";
      };
    in
    ''
      mkdir -p $out/share/icons
      mkdir -p $out/share/icons/Nordzy-Cursors
      cp -r "$src/NordArc-Icons" "$out/share/icons/NordArc"
      cp -r ${cursorSrc}/* $out/share/icons/Nordzy-Cursors
    '';
}
