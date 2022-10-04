{
  pkgs,
  stdenv,
  ...
}: let
  size = 16;
  inherit (pkgs.callPackage ./icons {}) nordic;
  mkCursorTheme = name: src:
    stdenv.mkDerivation {
      inherit name src;
      installPhase = ''
        mkdir $out/share/icons/${name} -p
        cp -r $src/* $out/share/icons/${name}
      '';
    };
in {
  breezeXBlack = rec {
    name = "BreezeXBlack";
    package = mkCursorTheme name (builtins.fetchTarball {
      url = "https://github.com/ful1e5/BreezeX_Cursor/releases/download/v1.0.3/BreezeX-Black.tar.gz";
      sha256 = "sha256:10sj6fmpxs8509lpjz7pj0iyahi29fn206m2lr5sv1ks9g6hnav4";
    });
    inherit size;
  };
  googleDotBlack = rec {
    name = "GoogleDotBlack";
    package = mkCursorTheme name (builtins.fetchTarball {
      url = "https://github.com/ful1e5/Google_Cursor/releases/download/v1.1.3/GoogleDot-Black.tar.gz";
      sha256 = "sha256:0kn49c99vk28iijrwp8cnv98sac3pb3jrk6pn12l3ws8q269363f";
    });
    inherit size;
  };
  posysImproved = rec {
    name = "Posy_Cursor"; # can also append _Black _Mono _Mono_Black and _Strokeless
    package = stdenv.mkDerivation {
      inherit name;
      src = pkgs.fetchgit {
        url = "https://github.com/simtrami/posy-improved-cursor-linux";
        sha256 = "0hm5sbwr5ban9a30zwjlnsamd0528m5ysz44vq52mcd8cqd3j02j";
        rev = "db36bf343471ea5dd9a9f596181f2559c6e09ddf";
      };
      installPhase = ''
        mkdir $out/share/icons/${name} -p
        cp -r $src/${name}/* $out/share/icons/${name}
      '';
    };
    inherit size;
  };
  numix = {
    name = "Numix-Cursor";
    package = pkgs.numix-cursor-theme;
    inherit size;
  };
  nordzyCursor = {
    name = "Nordzy-Cursors";
    package = nordic;
    inherit size;
  };
}
