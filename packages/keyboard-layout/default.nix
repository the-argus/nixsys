{
  runCommand,
  xorg,
  ...
}:
runCommand "keyboard-layout" {} ''
  ${xorg.xkbcomp}/bin/xkbcomp ${./layout.xkb} $out
''
