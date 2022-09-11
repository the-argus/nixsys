{
  emptyDirectory,
  stdenv,
  discordTheme,
  webcordPkg,
}:
stdenv.mkDerivation {
  name = "DiscordThemeInstaller";
  src = emptyDirectory;
  buildCommand = "${webcordPkg}/bin/webcord --add-css-theme=${discordTheme}";
  dontInstall = true;
  dontPatch = true;
  dontUnpack = true;
}
