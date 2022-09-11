{
  emptyDirectory,
  stdenv,
  discordTheme,
  webcordPkg,
}:
stdenv.mkDerivation {
  name = "DiscordThemeInstaller";
  src = emptyDirectory;
  buildCommand = ''
    mkdir userData
    XDG_CONFIG_HOME=userData
    ${webcordPkg}/bin/webcord --add-css-theme=${discordTheme}/THEME.theme.css
  '';
  dontInstall = true;
  dontPatch = true;
  dontUnpack = true;
}
