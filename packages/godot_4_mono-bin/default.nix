{
  pulseSupport ? true,
  alsaSupport ? false,
  stdenv,
  glibc,
  lib,
  xorg,
  fontconfig,
  libxkbcommon,
  makeWrapper,
  libGL,
  dbus,
  # libudev-zero,
  # using eudev because some symbols are missing from udev-zero
  eudev,
  alsaLib,
  pulseaudio,
  dotnet-netcore,
  ...
}:
stdenv.mkDerivation rec {
  version = "4.1.1-stable";
  pname = "godot";

  src = builtins.fetchTarball {
    url = "https://github.com/godotengine/godot/releases/download/${version}/Godot_v${version}_mono_linux_x86_64.zip";
    sha256 = "sha256:1h1mf429kxgbrgfibv494jw0pj0nfx112ghf7j5a2mbk7zsvzipv";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp -r $src/* $out/bin

    cp -r ${./share} $out/share

    mv $out/bin/Godot_v${version}_mono_linux.x86_64 $out/bin/godot4
  '';

  # needed, otherwise fails with "no version information available" on launch
  dontStrip = true;

  nativeBuildInputs = [makeWrapper];

  preFixup = let
    libraryPath = lib.makeLibraryPath [
      glibc
    ];
  in ''
    sed -i "s|__DERIVATION_PATH__|$out|g" $out/share/applications/org.godotengine.Godot4.desktop

    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${libraryPath}" \
      $out/bin/godot4
  '';

  postFixup = let
    dynamicLibraryPath = lib.makeLibraryPath ([
        xorg.libX11
        xorg.libXcursor
        xorg.libXext
        xorg.libXinerama
        xorg.libXrandr
        xorg.libXi
        fontconfig.lib
        libxkbcommon
        libGL
        dbus.lib
        # libudev-zero
        eudev
      ]
      ++ (lib.optionals alsaSupport [alsaLib])
      ++ (lib.optionals pulseSupport [pulseaudio]));

    binPath = lib.makeBinPath [dotnet-netcore];
  in ''
    wrapProgram $out/bin/godot4 \
      --prefix LD_LIBRARY_PATH : ${dynamicLibraryPath} \
      --prefix PATH : ${binPath}
  '';
}
