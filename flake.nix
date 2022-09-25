{
  description = "the-argus nixos system configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-22.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-remotebuild.url = "github:nixos/nixpkgs?ref=nixos-22.05";
    nixpkgs-localbuild.url = "github:nixos/nixpkgs?ref=nixos-22.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.05";
      # home manager use out nixpkgs and not its own
      inputs.nixpkgs.follows = "nixpkgs";
    };

    audio-plugins = {
      url = "github:the-argus/audio-plugins-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rycee-expressions = {
      url = "gitlab:rycee/nur-expressions";
      flake = false;
    };

    chrome-extensions = {
      url = "github:the-argus/chrome-extensions-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    webcord.url = "github:fufexan/webcord-flake";

    spicetify-nix = {
      url = "github:the-argus/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    gtk-nix = {
      url = "github:the-argus/gtk-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    modern-unix = {
      url = "github:the-argus/modern-unix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # non-nix imports (need fast updates):
    nvim-config = {
      url = "github:the-argus/nvim-config";
      flake = false;
    };

    arkenfox-userjs = {
      url = "github:arkenfox/user.js";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    nixpkgs-remotebuild,
    nixpkgs-localbuild,
    home-manager,
    webcord,
    rycee-expressions,
    # , nur
    audio-plugins,
    chrome-extensions,
    spicetify-nix,
    modern-unix,
    gtk-nix,
    nvim-config,
    arkenfox-userjs,
    ...
  } @ inputs: let
    # global configuration variables ---------------------------------------
    defaultGlobalSettings = rec {
      system = "x86_64-linux";
      username = "argus";
      hostname = "evil";
      # unfree packages that i explicitly use
      allowedUnfree = [
        "spotify-unwrapped"
        "reaper"
        "slack"
      ];
      allowBroken = false;
      plymouth = let
        name = "rings";
      in {
        themeName = name;
        themePath = "pack_4/${name}";
      };
      terminal = "kitty";
      extraExtraSpecialArgs = {mpkgs = audio-plugins.mpkgSets.${system};};
      extraSpecialArgs = {};
      additionalModules = [audio-plugins.homeManagerModule];
      packageSelections = {
        # packages to override with their unstable versions
        # all of these are things that i might want to move
        # to remotebuild at some point (so theyre FOSS)
        unstable = [
          "alejandra"
          "wl-color-picker"
          "heroic"
          "solo2-cli"
          "ani-cli"
          "ungoogled-chromium"
          "firefox"
          "linuxPackages_latest"
          "linuxPackages_zen"
          "linuxPackages_xanmod_latest"
          "OVMFFull"
          "neovim"
          "kitty"
        ];
        # packages to build remotely
        remotebuild = [
          # "linuxPackages_latest"
          # "linuxPackages_zen"
          # "linuxPackages_xanmod_latest"
          # "qtile"
        ];
        localbuild = [];
      };
      additionalUserPackages = [
        #"steam"
      ]; # will be evaluated later
      additionalOverlays = [];
      hardwareConfiguration = [./system/hardware];
      usesWireless = true; # install and autostart nm-applet
      usesBluetooth = true; # install and autostart blueman applet
      usesMouse = false; # enables xmousepasteblock for middle click
      usesEthernet = false;
      hasBattery = true; # battery widget in tiling WMs
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
      additionalSystemPackages = [];
      name = "pkgs";
      remotebuildOverrides = {name = "remotebuild";};
      localbuildOverrides = {name = "localbuild";};
      unstableOverrides = {name = "unstable";};
    };

    # based on those settings, create any additional entries that
    # will be needed by the configuration

    finalizeSettings = settings: let
      optimizedStdenv = pkgsToOptimize: let
        inherit (settings.optimization) USE arch useClang useNative;
        mkStdenv = march: stdenv:
        # adds -march flag to the global USE flags and creates stdenv
          pkgsToOptimize.withCFlags
          (USE ++ ["-march=${march}" "-mtune=${march}"])
          stdenv;

        # same thing but use -march=native
        mkNativeStdenv = stdenv:
          pkgsToOptimize.impureUseNativeOptimizations
          (pkgsToOptimize.stdenvAdapters.withCFlags USE stdenv);

        optimizedStdenv = mkStdenv arch pkgsToOptimize.stdenv;
        optimizedClangStdenv =
          mkStdenv arch pkgsToOptimize.llvmPackages_14.stdenv;

        optimizedNativeClangStdenv =
          nixpkgs.lib.warn "using native optimizations, \
                forfeiting reproducibility"
          mkNativeStdenv
          pkgsToOptimize.llvmPackages_14.stdenv;
        optimizedNativeStdenv =
          nixpkgs.lib.warn "using native optimizations, \
                forfeiting reproducibility"
          mkNativeStdenv
          pkgsToOptimize.stdenv;
      in
        if useNative
        then
          if useClang
          then optimizedNativeClangStdenv
          else optimizedNativeStdenv
        else if useClang
        then optimizedClangStdenv
        else optimizedStdenv;

      systemCompilerSettings = {
        gcc = {
          arch = settings.optimization.arch;
          tune = settings.optimization.arch;
        };
      };

      mkPkgsInputs = settingsSet: let
        inherit (settingsSet.optimization) useMusl useFlags;
        inherit (settingsSet) allowedUnfree system plymouth name;
      in {
        config =
          {
            inherit (settingsSet) allowBroken;
            allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) allowedUnfree;
          }
          // (
            if
              settingsSet.optimization.useFlags
              or settingsSet.optimization.useClang
            then {
              replaceStdenv = {
                pkgs,
                unstable,
                remotebuild,
                localbuild,
              }: let
                pkgSets = {inherit unstable remotebuild localbuild pkgs;};
              in
                builtins.trace "Optimizing for ${settingsSet.name}" (optimizedStdenv (pkgSets.${settingsSet.name}));
            }
            else {}
          );
        localSystem =
          {
            inherit system;
          }
          // (
            if useMusl
            then {
              libc = "musl";
              config = "x86_64-unknown-linux-musl";
            }
            else {}
          )
          // (
            if useFlags
            then systemCompilerSettings
            else {}
          );

        overlays =
          settings.additionalOverlays
          ++ [
            (self: super: {
              plymouth-themes-package = import ./packages/plymouth-themes.nix ({
                  pkgs = super;
                }
                // plymouth);
            })
            # also add the theme to pkgs
          ]
          ++ (
            if (builtins.hasAttr "theme" settingsSet)
            then [
              (self: super: {
                flakeTheme = settingsSet.theme;
              })
            ]
            else []
          );
      };

      override = nixpkgs.lib.attrsets.recursiveUpdate;

      # modify pkgsInputSet to include overlays from settings.packageSelections
      mkOverlays = pkgSet: pkgsInputSet: selections:
        override pkgsInputSet {
          overlays =
            pkgsInputSet.overlays
            # turn selections into an attrset of the packages for overlay
            # wrapped in (self: super: ...) so it works as an overlay
            ++ nixpkgs.lib.lists.singleton (self: super:
              builtins.listToAttrs (map (value:
                if builtins.typeOf value == "string"
                then {
                  name = value;
                  value = pkgSet.${value};
                }
                else if builtins.typeOf value == "set"
                then
                  if builtins.hasAttr "set3" value
                  then {
                    name = value.set1;
                    value = override pkgSet.${value.set1} {
                      ${value.set2} = {
                        ${value.set3} =
                          pkgSet.${value.set1}.${value.set2}.${value.set3};
                      };
                    };
                  }
                  else
                    (
                      if builtins.hasAttr "set2" value
                      then {
                        name = value.set1;
                        value = override pkgSet.${value.set1} {
                          ${value.set2} = pkgSet.${value.set1}.${value.set2};
                        };
                      }
                      else {}
                    )
                else abort "override not one of type \"set\" or \"string\"")
              selections));
        };

      # create the package sets
      unstable = import nixpkgs-unstable (mkPkgsInputs (
        override settings (settings.unstableOverrides)
      ));
      remotebuild =
        # version of pkgs meant to be compiled on remote aarch64 server
        import nixpkgs-remotebuild
        (override (override (mkPkgsInputs settings) {
            localSystem.system = "aarch64-linux";
            crossSystem.system = "x86_64-linux";
          })
          settings.remotebuildOverrides);
      localbuild =
        # version of pkgs meant to be compiled on remote aarch64 server
        import nixpkgs-localbuild
        (override (mkPkgsInputs settings)
          settings.remotebuildOverrides);
      # add the overlays to pkgInputs
      pkgs =
        import nixpkgs
        (mkOverlays unstable
          (mkOverlays remotebuild
            (mkOverlays localbuild
              (mkPkgsInputs settings)
              settings.packageSelections.localbuild)
            settings.packageSelections.remotebuild)
          settings.packageSelections.unstable);
    in (nixpkgs.lib.trivial.mergeAttrs settings rec {
      features = ["gccarch-${settings.optimization.arch}"];
      inherit pkgs unstable remotebuild localbuild;
      homeDirectory = "/home/${settings.username}";
      firefox-addons =
        (import "${rycee-expressions}" {
          inherit pkgs;
        })
        .firefox-addons;
    });
  in rec
  {
    createNixosConfiguration = settings: let
      fs = finalizeSettings settings;
    in {
      ${fs.hostname} = nixpkgs.lib.nixosSystem {
        inherit (fs) pkgs system;
        specialArgs =
          inputs
          // fs.extraSpecialArgs
          // {
            inherit (fs) unstable hostname username useMusl remotebuild;
            inherit (fs) useFlags plymouth usesWireless usesBluetooth;
            inherit (fs) usesEthernet localbuild;
            settings = fs;
          };
        modules = [
          {
            imports = [./system/configuration.nix ./modules];
          }
        ];
      };
    };

    createHomeConfigurations = settings: let
      fs = finalizeSettings settings;
    in
      home-manager.lib.homeManagerConfiguration rec {
        inherit (fs) pkgs system username homeDirectory;
        configuration = {pkgs, ...}: {
          imports = [./user/primary] ++ fs.additionalModules;
        };
        stateVersion = "22.05";
        extraSpecialArgs =
          inputs
          // {
            inherit (fs) homeDirectory firefox-addons;
          }
          // fs.extraExtraSpecialArgs
          // {
            inherit (fs) unstable hostname username useMusl remotebuild;
            inherit (fs) useFlags plymouth usesWireless usesBluetooth;
            inherit (fs) additionalUserPackages;
            settings = fs;
          };
      };

    inherit finalizeSettings;

    nixosConfigurations = createNixosConfiguration defaultGlobalSettings;
    homeConfigurations.${defaultGlobalSettings.username} =
      createHomeConfigurations defaultGlobalSettings;
    devShell.${defaultGlobalSettings.system} =
      (finalizeSettings defaultGlobalSettings).pkgs.mkShell {};
  };
}
