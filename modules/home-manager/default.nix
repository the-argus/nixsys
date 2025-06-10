{...}: {
  imports = [
    ./desktops
    ./gaming
    ./dvorak.nix
    ../hardware.nix
  ];

  xsession.enable = true;
  home.file.".config/xkb/symbols/custom".source = ../../packages/patched_xkeyboardconfig/cycle-special-keys;
}
