{
  system = "x86_64-linux";
  username = "argus";
  hostname = "evil";
  # unfree packages that i explicitly use
  allowedUnfree = [
    "spotify"
    "reaper"
    "slack"
    "discord"
    "p4"
    "steam-run"
    "steam-run-native"
    "steam-original"
    "obsidian"
  ];
  allowBroken = false;
  extraExtraSpecialArgs = {};
  extraSpecialArgs = {};
  additionalModules = [];
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
          linuxPackages_latest
          linuxPackages_zen
          linuxPackages_xanmod_latest
          OVMFFull
          neovim
          kitty
          spotify
          godot_4
          ;
        nodePackages =
          original.nodePackages
          // (with nodePackages; {
            inherit live-server;
          });
      };
    # packages to build remotely
    remotebuild = _: _: {};
    localbuild = _: _: {};
  };
  additionalOverlays = [];
  additionalNixosModules = [../system/hardware];
  optimization = {
    arch = "tigerlake";
    # use musl instead of glibc
    useMusl = false;
    # compile everything from source
    useFlags = false;

    useNative = false;
    useClang = false;
    # what optimizations to use (check https://github.com/fortuneteller2k/nixpkgs-f2k/blob/ca75dc2c9d41590ca29555cddfc86cf950432d5e/flake.nix#L237-L289)
    USE = [
      # "-O3"
      "-O2"
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
  nix = {}; # dont edit nix settings
  name = "pkgs";
  remotebuildOverrides = {name = "remotebuild";};
  localbuildOverrides = {name = "localbuild";};
  unstableOverrides = {name = "unstable";};
}
