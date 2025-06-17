# most scuffed way of adding a keyboard layout...
{xorg, ...}:
xorg.xkeyboardconfig.overrideAttrs (_: {
  postPatch = ''
    cp ${./cycle-special-keys} symbols/custom
  '';
})
