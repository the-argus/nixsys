{
  nixpkgs,
  hostname ? "mutant",
  ...
}: let
  override = nixpkgs.lib.attrsets.recursiveUpdate;
in rec {
  # theme = "gruvboxWithGtkNix";
  theme = "gruvbox";
  system = "x86_64-linux";
  username = "argus";
  inherit hostname;
  # unfree packages that i explicitly use
  allowedUnfree = [
    "spotify"
    "reaper"
    "slack"
    "steam"
    "steam-run"
    "steam-original"
    "steam-unwrapped"
    "discord"
    "ue4"
    "zoom"
    "rider"
    "aseprite"
    "libXNVCtrl"
  ];
  allowBroken = false;
  extraExtraSpecialArgs = {};
  extraSpecialArgs = {};
  additionalModules = [
    ./shared
    ./home-manager
  ];
  additionalOverlays = [
    (_: super: {
      steam = super.steam.override {
        extraLibraries = _: [super.mesa.drivers];
      };
    })
  ];
  additionalNixosModules = [./hardware ./shared];
  packageSelections = {
    remotebuild = remotebuild: _:
      with remotebuild; {
        # inherit
        #   dash
        #   grub
        #   ;
      };
    unstable = unstable: original:
      with unstable; {
        inherit
          alejandra
          wl-color-picker
          heroic
          solo2-cli
          ani-cli
          ungoogled-chromium
          firefox
          ferium
          OVMFFull
          linuxPackages_xanmod_latest
          prismlauncher
          godot_4
          ;
        linuxKernel =
          original.linuxKernel
          // {
            kernel =
              original.kernel
              // {
                inherit (unstable) xanmod_latest;
              };
          };
      };
    localbuild = localbuild: _:
      with localbuild; {
        inherit
          gnome
          plymouth
          gdm
          qtile
          zsh
          zplug
          kitty
          ;
        # xorg
        # systemd
      };
  };
  optimization = {
    arch = "znver1";
    useMusl = false; # use musl instead of glibc
    useFlags = false; # use USE
    useClang = false; # cland stdenv
    useNative = false; # native march
    # what optimizations to use (check https://github.com/fortuneteller2k/nixpkgs-f2k/blob/ca75dc2c9d41590ca29555cddfc86cf950432d5e/flake.nix#L237-L289)
    USE = [
      "-O3"
      # "-O2"
      "-pipe"
      "-ffloat-store"
      "-fexcess-precision=fast"
      "-ffast-math"
      "-fno-rounding-math"
      "-fno-signaling-nans"
      "-fno-math-errno"
      "-funsafe-math-optimizations"
      "-fassociative-math"
      "-freciprocal-math"
      "-ffinite-math-only"
      "-fno-signed-zeros"
      "-fno-trapping-math"
      "-frounding-math"
      "-fsingle-precision-constant"
      # not supported on clang 14 yet, and isn't ignored
      # "-fcx-limited-range"
      # "-fcx-fortran-rules"
    ];
  };
  nix = {
    distributedBuilds = true;
    buildMachines = [
      {
        hostName = "rpmc.duckdns.org";
        systems = ["aarch64-linux"];
        sshUser = "servers";
        sshKey = "/home/argus/.ssh/id_ed25519";
        supportedFeatures = ["big-parallel"];
        maxJobs = 4;
        speedFactor = 2;
      }
    ];
  };
  additionalSystemPackages = [];
  name = "pkgs";
  remotebuildOverrides = {
    optimization = {
      useMusl = true;
      useFlags = true;
      useClang = true;
    };
    name = "remotebuild";
  };
  unstableOverrides = {
    additionalOverlays = let
      kernel = import ./hardware/kernel-overlay.nix {
        inherit override hostname;
        basekernelsuffix = "xanmod_latest";
      };
    in [
      # kernel
    ];
    name = "unstable";
  };
  localbuildOverrides = override remotebuildOverrides {
    optimization = {
      useMusl = false;
      useFlags = true;
      useClang = true;
    };
    name = "localbuild";
  };
}
