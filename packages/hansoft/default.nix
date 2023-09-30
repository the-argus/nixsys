{
  stdenv,
  lib,
  unzip,
  requireFile,
  glibc,
  xorg,
  freetype,
  eudev,
  alsa-lib,
  libuuid,
  libxkbcommon,
  fontconfig,
  harfbuzz,
  glib,
  krb5,
  ...
}:
stdenv.mkDerivation {
  pname = "hansoft";
  version = "11.1041";

  src = requireFile {
    # NOTE: you must rename the downloaded file to have underscores
    name = "Hansoft_11.1041_Linux2.6_x64.zip";
    url = "https://cache.hansoft.com/Hansoft%2011.1041%20Linux2.6%20x64.zip";
    sha256 = "17yapjd2gpw613hsrxirr6zmahacl0pds90pp3nfkjf5j8r3wg61";
  };

  nativeBuildInputs = [unzip];

  dontStrip = true;

  preFixup = let
    libraryPath = lib.makeLibraryPath ([
        glibc
        freetype
        eudev
        alsa-lib
        libuuid.lib
        libxkbcommon
        fontconfig.lib
        harfbuzz
        glib
        krb5
      ]
      ++ (with xorg; [
        libX11
        libICE
        libxcb
        libSM
        libXrender
        libXext
        xcbutilrenderutil
        xcbutilimage
        xcbutilkeysyms
        xcbutil
        xcbutilwm
      ]));
  in ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${libraryPath}" \
      $out/bin/hansoft
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv Hansoft $out/bin/hansoft

    mkdir -p $out/share/applications
    desktop=$out/share/applications/hansoft.desktop
    cp ${./hansoft.desktop} $desktop
    chmod +wr $out/share/applications/hansoft.desktop $desktop
    echo "Exec=$out/bin/hansoft %f" >> $desktop
  '';
}
