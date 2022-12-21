{
  settings,
  lib,
  ...
}:
lib.attrsets.optionalAttrs settings.useDvorak {
  console.keyMap = "dvorak-programmer";
  services = {
    xserver = {
      layout = "us";
      xkbVariant = "dvp,";
      xkbOptions = "compose:ralt,caps:ctrl_modifier,grp_led:caps";
    };
  };
}
