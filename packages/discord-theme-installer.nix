{
  emptyDirectory,
  stdenv,
  fontconfig,
  discordTheme,
  webcordPkg,
}:
stdenv.mkDerivation {
  name = "DiscordThemeInstaller";
  src = emptyDirectory;
  buildInputs = [
    fontconfig
  ];
  buildCommand = ''
    mkdir userData
    XDG_CONFIG_HOME=userData
    ${webcordPkg}/bin/webcord --add-css-theme=${discordTheme}/THEME.theme.css -m
  '';
  dontInstall = true;
  dontPatch = true;
  dontUnpack = true;
}
