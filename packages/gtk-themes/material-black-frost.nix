{ pkgs, stdenv, coreutils-full, ... }:
stdenv.mkDerivation {
  name = "MaterialBlackFrost-Theme";
  src = pkgs.fetchgit {
    url = "https://github.com/rtlewis88/rtl88-Themes";
    rev = "c8d57d6ee1ce8156b2a873bb064b493e9421cf61";
    sha256 = "0vk1hslfglqk8vpp4h403hzxkj447y5plf04swk5h5jcz21ik265";
  };
  installPhase = ''
    mkdir $out
    cp $src/* $out
    ${coreutils-full}/bin/chmod w+r $out/*
    # README causes a collision in home manager path for some reason
    rm $out/README.md
  '';
}
