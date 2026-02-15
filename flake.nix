{
  description = "the-argus nixos system configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-nvim-pinned.url = "github:nixos/nixpkgs?rev=3497aa5c9457a9d88d71fa93a4a8368816fbeeba"; # nixpkgs-unstable as of 02-15-2026
    nixpkgs-master.url = "github:nixos/nixpkgs?ref=master";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      # home manager use our nixpkgs and not its own
      inputs.nixpkgs.follows = "nixpkgs";
    };

    banner.url = "github:the-argus/banner.nix";

    audio-plugins.url = "github:the-argus/audio-plugins-nix";

    rycee-expressions = {
      url = "gitlab:rycee/nur-expressions";
      flake = false;
    };

    bitwarden-rofi = {
      url = "github:the-argus/bitwarden-rofi";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    chrome-extensions = {
      url = "github:the-argus/chrome-extensions-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    gtk-nix = {
      url = "github:the-argus/gtk-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nobar = {
      url = "github:the-argus/nobar";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvim-config = {
      url = "github:the-argus/nvim-config";
      inputs.nixpkgs.follows = "nixpkgs-nvim-pinned";
    };

    # non-nix imports (need fast updates):
    arkenfox-userjs = {
      url = "github:arkenfox/user.js";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    # nixpkgs-master,
    home-manager,
    rycee-expressions,
    # , nur
    audio-plugins,
    ...
  } @ inputs: let
    myLib = import ./lib {inherit (nixpkgs) lib;};
    defaultGlobalSettings = myLib.globalConfig.defaults;
    finalizeSettings = myLib.globalConfig.mkFinalizer {
      inherit nixpkgs nixpkgs-unstable;
    };
    stateVersion = "22.11";

    hosts = {
      laptop = import ./hosts/laptop {
        inherit nixpkgs;
        hostname = "evil";
      };
      pc = import ./hosts/pc {
        inherit nixpkgs;
        hostname = "mutant";
      };
      tui = import ./hosts/tui {
        inherit nixpkgs;
      };
    };
  in {
    createNixosConfiguration = settings: let
      fs = finalizeSettings settings;
    in
      nixpkgs.lib.nixosSystem {
        inherit (fs) pkgs system;
        specialArgs =
          inputs
          // fs.extraSpecialArgs
          // {
            inherit (fs) unstable localbuild useMusl remotebuild;
            inherit (fs) useFlags plymouth;
            inherit (fs) hostname username;
            inherit stateVersion;
            settings = fs;
          };
        modules = [
          {
            imports = [./system/configuration.nix ./modules] ++ fs.additionalNixosModules;
          }
        ];
      };

    createHomeConfigurations = userFolder: settings: let
      fs = finalizeSettings settings;
      inherit
        (import "${rycee-expressions}" {inherit (fs) pkgs;})
        firefox-addons
        ;
    in
      home-manager.lib.homeManagerConfiguration rec {
        inherit (fs) pkgs;
        modules =
          [
            userFolder
            audio-plugins.homeManagerModules.${fs.system}

            ./modules/color/themes.nix
            ./modules/home-manager
            ({...}: {
              home = {
                inherit (fs) username;
                inherit stateVersion;
                homeDirectory = "/home/${fs.username}";
              };
            })
          ]
          ++ fs.additionalModules;
        extraSpecialArgs =
          inputs
          // {
            inherit (fs) homeDirectory;
            inherit firefox-addons;
            mpkgs = audio-plugins.mpkgSets.${fs.system};
          }
          // fs.extraExtraSpecialArgs
          // {
            inherit (fs) unstable remotebuild localbuild;
            inherit (fs) useFlags useMusl useClang;
            inherit (fs) hostname username;
            inherit stateVersion;
            settings = fs;
          };
      };

    inherit finalizeSettings;

    nixosConfigurations = {
      default = self.createNixosConfiguration defaultGlobalSettings;
      laptop = self.createNixosConfiguration hosts.laptop;
      ${hosts.laptop.hostname} = self.nixosConfigurations.laptop;
      pc = self.createNixosConfiguration hosts.pc;
      ${hosts.pc.hostname} = self.nixosConfigurations.pc;
    };
    homeConfigurations = {
      default = self.createHomeConfigurations ./user/primary defaultGlobalSettings;
      laptop = self.createHomeConfigurations ./user/primary hosts.laptop;
      pc = self.createHomeConfigurations ./user/primary hosts.pc;
      tui = self.createHomeConfigurations ./user/tui hosts.tui;
    };
    devShell.${defaultGlobalSettings.system} =
      (finalizeSettings defaultGlobalSettings).pkgs.mkShell {};

    packages.${defaultGlobalSettings.system} = {
      # wacky setup to make sure typst is unstable
      myPackages = let
        fs = finalizeSettings defaultGlobalSettings;
        called = fs.pkgs.callPackage ./packages {};
        unstableCalled = fs.unstable.callPackage ./packages {};
      in
        called // {inherit (unstableCalled) typst;};
    };

    formatter.${defaultGlobalSettings.system} = (finalizeSettings defaultGlobalSettings).pkgs.alejandra;
  };
}
