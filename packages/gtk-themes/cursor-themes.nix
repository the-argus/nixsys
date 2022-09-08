{ pkgs, ... }:
let
  size = 16;
  inherit (pkgs.callPackage ./icons { }) nordic;
in
{
  breezeXBlack = {
    name = "BreezeXBlack";
    package = builtins.fetchTarball {
      url = "https://github.com/ful1e5/BreezeX_Cursor/releases/download/v1.0.3/BreezeX-Black.tar.gz";
      sha256 = "sha256:10sj6fmpxs8509lpjz7pj0iyahi29fn206m2lr5sv1ks9g6hnav4";
    };
  };
  googleDotBlack = {
    name = "GoogleDotBlack";
    package = builtins.fetchTarball {
      url = "https://github.com/ful1e5/Google_Cursor/releases/download/v1.1.3/GoogleDot-Black.tar.gz";
      sha256 = "112ycb125aiy467439ndgwl7f8a8lbzcn3fmyv3m3gvz0nq6knh6";
    };
    inherit size;
  };
  posysImproved = {
    package = pkgs.fetchgit {
      url = "https://github.com/simtrami/posy-improved-cursor-linux";
      sha256 = "0hm5sbwr5ban9a30zwjlnsamd0528m5ysz44vq52mcd8cqd3j02j";
      rev = "db36bf343471ea5dd9a9f596181f2559c6e09ddf";
    };
    name = "Posy_Cursor"; # can also append _Black _Mono _Mono_Black and _Strokeless
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