{...}: {
  imports = [
    ./desktops.nix
    ./hardware.nix
  ];

  gaming.minecraft = true;
  gaming.enable = true;
}
