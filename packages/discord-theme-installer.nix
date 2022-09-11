{
  emptyDirectory,
  stdenv,
  discordTheme,
}:
stdenv.mkDerivation {
  src = emptyDirectory;
  buildCommand = "${webcordPkg}/bin/webcord --add-css-theme=${discordTheme}";
  dontInstall = true;
  dontPatch = true;
  dontUnpack = true;
}
