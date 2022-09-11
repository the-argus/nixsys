{
  pkgs,
  stdenv,
  ...
}:
stdenv.mkDerivation {
  name = "MaterialBlackFrost-Theme";
  src = pkgs.fetchgit {
    url = "https://github.com/rtlewis88/rtl88-Themes";
    rev = "c8d57d6ee1ce8156b2a873bb064b493e9421cf61";
    sha256 = "0vk1hslfglqk8vpp4h403hzxkj447y5plf04swk5h5jcz21ik265";
  };
  installPhase = ''
    mkdir $out/share/themes -p
    mkdir $out/share/icons -p
    cp -r $src/Black-Frost-Numix-FLAT $out/share/icons
    cp -r $src/Black-Frost-Numix $out/share/icons
    cp -r $src/Black-Frost-Suru $out/share/icons
    cp $src/Material-Black-Frost $out/share/themes -r
  '';
}
