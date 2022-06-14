{ pkgs, lib, ... }:
# original file https://github.com/NixOS/nixpkgs/blob/1cf5591a99f9d1f0b4bff66f1533917f4c597112/pkgs/applications/audio/airwave/default.nix
pkgs.airwave.overrideAttrs (finalAttrs: previousAttrs:

  let
    vst-sdk = pkgs.stdenv.mkDerivation rec {
      name = "vstsdk368_08_11_2017_build_121";
      src = pkgs.fetchurl {
        name = "${name}.zip";
        # this file is on the wayback machine and therefore retrieving it is
        # unstable at best, and it may go away in the future. right now it is
        # needed to build airwave. I'll keep it backed up on some of my hard drives
        # has the correct file structure apparently
        url = "https://web.archive.org/web/20180801111336/https://download.steinberg.net/sdk_downloads/vstsdk369_01_03_2018_build_132.zip";
        sha256 = "7c6c2a5f0bcbf8a7a0d6a42b782f0d3c00ec8eafa4226bbf2f5554e8cd764964";
      };
      nativeBuildInputs = [ pkgs.unzip ];

      # combine vst2 and 3
      # configurePhase = "cp -r ./vst2sdk/* vst3sdk/.";
      installPhase = "cp -r . $out";
    };
  in
  {
    cmakeFlags = [ ''-D CMAKE_BUILD_TYPE="Release"'' ''-D VSTSDK_PATH=${vst-sdk}/VST2_SDK'' ];
    # build fails without this package
    buildInputs = [ pkgs.qt5.wrapQtAppsHook pkgs.file ];
  })
