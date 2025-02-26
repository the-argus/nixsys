{
  config,
  lib,
  modulesPath,
  settings,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

  nix.settings.system-features =
    ["nixos-test" "benchmark" "big-parallel" "kvm"]
    ++ settings.features;

  boot.initrd.availableKernelModules = ["nvme" "ahci" "xhci_pci" "usb_storage" "usbhid" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXROOT";
    fsType = "ext4";
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-label/NIXHOME";
    fsType = "ext4";
  };

  fileSystems."/home/argus/shared" = {
    device = "/dev/disk/by-label/NTFSHOME";
    fsType = "ntfs-3g";
    options = ["rw" "uid=1000"];
  };

  fileSystems."/home/argus/external" = {
    device = "/dev/disk/by-label/EXT4SSD";
    fsType = "ext4";
  };

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-label/WINBOOT";
    fsType = "vfat";
  };

  swapDevices = [
    {
      device = "/.swapfile";
      size = 4069;
    }
  ];

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
