{
  lib,
  stdenvNoCC,
  makeWrapper,
  coreutils-prefixed,
  coreutils,
  gawk,
  file,
  librsvg,
  imagemagick_light,
  ffmpeg,
  ffmpegthumbnailer,
  poppler-utils,
  fontforge,
  ncurses,
  highlight,
  glow,
  unrar-wrapper,
  unzip,
  p7zip,
  gnutar,
  ...
}: let
  binPath = [
    coreutils-prefixed # gstat
    gawk # awk
    coreutils # md5sum, readlink, tr, basename
    file
    librsvg.out # rsvg-convert
    imagemagick_light.out # convert, identify
    ffmpeg
    ffmpegthumbnailer
    poppler-utils # pdftoppm
    fontforge # fontimage, for font previews
    ncurses # tput
    highlight
    glow
    unrar-wrapper
    unzip
    p7zip
    gnutar
  ];
in
  stdenvNoCC.mkDerivation
  {
    name = "lf-kitty-previewer";
    version = "0.0.1";

    src = ./lf-kitty-previewer.sh;

    dontUnpack = true;
    dontBuild = true;

    buildInputs = [makeWrapper];

    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/lf-kitty-previewer.sh
      ${coreutils}/bin/chmod +wx $out/bin/lf-kitty-previewer.sh
    '';

    postFixup = ''
      patchShebangs --host $out/bin/lf-kitty-previewer.sh

      wrapProgram \
          $out/bin/lf-kitty-previewer.sh \
          --prefix PATH ":" ${lib.makeBinPath binPath}
    '';
  }
