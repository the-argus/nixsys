{ stdenv, fetchgit, gtk-engine-murrine, ... }:
{
  name = "Orchis";
  pkg = stdenv.mkDerivation rec {
    pname = "Orchis-Theme";
    version = "2022-07-20";

    src = fetchgit {
      url = "https://github.com/vinceliuice/Orchis-theme";
      sha256 = "0lbylwjl52vnh7yfxqx0j9df8m49zwwvjn1vrdlkk5rpxcxarrwl";
      rev = "54196b9d5da5ec505e05491fc42533ed0c0d676a";
    };

    propagatedUserEnvPkgs = [ gtk-engine-murrine ];

    installPhase = ''
      mkdir -p $out/share/themes/Orchis
      cp -r src/* $out/share/themes/Orchis
    '';
  };
}
