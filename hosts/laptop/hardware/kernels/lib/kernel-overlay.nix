{
  override,
  baseKernelSuffix,
  hostname,
  kernelConfig ? ../5_19_builtin.nix,
  ...
}: (self: super: let
  dirVersionNames = {
    xanmod_latest = "xanmod";
    "5_15" = "";
    "5_19" = "";
  };
  dirVersionName =
    if builtins.hasAttr baseKernelSuffix dirVersionNames
    then
      (
        if dirVersionNames.${baseKernelSuffix} == ""
        then ""
        else "-${dirVersionNames.${baseKernelSuffix}}1"
      )
    else baseKernelSuffix;
  basekernel = "linux_${baseKernelSuffix}";
  src = super.linuxKernel.kernels.${basekernel}.src;
  version = super.linuxKernel.kernels.${basekernel}.version;
in {
  linuxKernel = override super.linuxKernel {
    kernels = {
      linux_xanmod_latest =
        (super.linuxKernel.manualConfig {
          stdenv = super.gccStdenv;
          inherit src version;
          modDirVersion = "${version}-${super.lib.strings.toUpper hostname}${dirVersionName}";
          inherit (super) lib;
          configfile = super.callPackage kernelConfig {
            inherit hostname;
          };
          allowImportFromDerivation = true;
        })
        .overrideAttrs (oa: {
          nativeBuildInputs = (oa.nativeBuildInputs or []) ++ [super.lz4];
          # originally "xhci_pci thunderbolt nvme usb_storage sd_mod md_mod raid0 raid1 raid10 raid456 ext2 ext4 ahci sata_nv sata_via sata_sis sata_uli ata_piix pata_marvell sd_mod sr_mod mmc_block uhci_hcd ehci_hcd ehci_pci ohci_hcd ohci_pci xhci_hcd xhci_pci usbhid hid_generic hid_lenovo hid_apple hid_roccat hid_logitech_hidpp hid_logitech_dj hid_microsoft hid_cherry pcips2 atkbd i8042 rtc_cmos dm_mod"
          passthru =
            oa.passthru
            // {
              features = {
                # this needs to match the kernel config since im forcing these
                ia32Emulation = true;
                efiBootStub = true;
              };
            };
        });
    };
  };
})
