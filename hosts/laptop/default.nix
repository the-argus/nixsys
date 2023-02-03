{nixpkgs, hostname ? "evil", ...}: let
  override = nixpkgs.lib.attrsets.recursiveUpdate;
in rec {
  # theme = "amber-forest";
  # theme = "nordicWithGtkNix";
  # theme = "drifter";
  theme = "gruvboxWithGtkNix";
  system = "x86_64-linux";
  username = "argus";
  inherit hostname;
  useDvorak = true;
  # unfree packages that i explicitly use
  allowedUnfree = [
    "obsidian"
    "spotify"
    "reaper"
    "slack"
    "discord"
    "ue4"
    "aseprite"
    "steam"
    "steam-original"
  ];
  allowBroken = true;
  extraExtraSpecialArgs = {};
  extraSpecialArgs = {};
  additionalModules = [./shared ./home-manager];
  additionalOverlays = [];
  packageSelections = {
    # packages to override with their unstable versions
    # all of these are things that i might want to move
    # to remotebuild at some point (so theyre FOSS)
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
          OVMFFull
          ;
        linuxKernel =
          original.linuxKernel
          // {
            kernels =
              original.linuxKernel.kernels
              // {
                inherit (unstable) linux_xanmod_latest;
              };
          };
      };
    localbuild = localbuild: _:
      with localbuild; {
        inherit
          # "xorg"
          gnome-shell
          gdm
          qtile
          zsh
          zplug
          kitty
          starship
          ;
      };
    remotebuild = _: _: {};
  };
  additionalNixosModules = [./hardware ./shared];
  optimization = {
    arch = "tigerlake";
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
  # nix = {
  #   distributedBuilds = true;
  #   buildMachines = [
  #     {
  #       hostName = "rpmc.duckdns.org";
  #       systems = ["aarch64-linux"];
  #       sshUser = "servers";
  #       sshKey = "/home/argus/.ssh/id_ed25519";
  #       supportedFeatures = ["big-parallel"];
  #       maxJobs = 4;
  #       speedFactor = 2;
  #     }
  #   ];
  # };
  name = "pkgs";
  remotebuildOverrides = {
    # optimization = {
    #   useMusl = true;
    #   useFlags = true;
    #   useClang = true;
    # };
    name = "remotebuild";
  };
  unstableOverrides = {
    name = "unstable";
    additionalOverlays = let
      kernel = import ./hardware/kernels/lib/kernel-overlay.nix {
        inherit override hostname;
        baseKernelSuffix = "xanmod_latest";
        kernelConfig = ./hardware/kernels/5_19.nix;
      };
    in [
      # kernel
    ];
  };
  localbuildOverrides = override remotebuildOverrides {
    # optimization.useMusl = false;
    name = "localbuild";
  };
}
