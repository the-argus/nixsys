{
  description = "the-argus nixos system configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-22.05";
    # nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.05";
      # home manager use out nixpkgs and not its own
      inputs.nixpkgs.follows = "nixpkgs";
    };

    audio-plugins = {
      url = "github:the-argus/audio-plugins-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    webcord = {
      url = "github:fufexan/webcord-flake";
    };

    # nur = {
    #   url = "github:nix-community/NUR";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    rycee-expressions = {
      url = "gitlab:rycee/nur-expressions";
      flake = false;
    };

    chrome-extensions = {
      url = "github:the-argus/chrome-extensions-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:the-argus/spicetify-nix";
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

  outputs =
    { self
    , nixpkgs
    , nixpkgs-unstable
    , home-manager
    , webcord
    , rycee-expressions
      # , nur
    , audio-plugins
    , chrome-extensions
    , spicetify-nix
    , nvim-config
    , arkenfox-userjs
    , ...
    }@inputs:
    let
      system = "x86_64-linux";
      username = "argus";
      homeDirectory = "/home/${username}";
      pkgs = import nixpkgs { inherit system; };
      unstable = import nixpkgs-unstable {
        inherit system; config.allowUnfreePredicate =
        pkg: builtins.elem (pkgs.lib.getName pkg) [
          "spotify-unwrapped"
          "reaper"
        ];
      };

      firefox-addons = (import "${rycee-expressions}" { inherit pkgs; }).firefox-addons;

      plymouth = let name = "rings"; in
        {
          themeName = name;
          themePath = "pack_4/${name}";
        };

      overlays = [
        (self: super: {
          # better discord performance, if its not installed via flatpak
          discord = super.discord.override {
            commandLineArgs =
              "--no-sandbox --enable-accelerated-mjpeg-decode --enable-accelerated-video --ignore-gpu-blacklist --enable-native-gpu-memory-buffers --enable-gpu-rasterization";
          };
        })

        (self: super: {
          plymouth-themes-package = import ./packages/plymouth-themes.nix ({
            inherit pkgs;
          } // plymouth);
        })
      ];

      # whether to use laptop or PC configuration
      hardware = "laptop";
    in
    {
      nixosConfigurations = {
        # hostname (evil)
        evil = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = inputs // {
            inherit hardware; inherit unstable; inherit plymouth;
          };
          modules = [
            {
              nixpkgs.overlays = overlays;
              imports = [ ./system/configuration.nix ];
            }
          ];
        };
      };

      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        inherit system username homeDirectory;
        configuration = { pkgs, ... }: {
          imports = [ ./user/${username} audio-plugins.homeManagerModule ];
          nixpkgs.overlays = overlays;
        };
        stateVersion = "22.05";
        extraSpecialArgs = inputs // { inherit hardware unstable homeDirectory firefox-addons; mpkgs = audio-plugins.mpkgs; };
      };

      devShell.${system} =
        pkgs.mkShell {
          shellHook = ''
            alias usrbuild="home-manager switch --flake ."
            alias sysbuild="nixos-rebuild switch --use-remote-sudo --flake ."
            alias rebuild="sysbuild && usrbuild"
            alias update="git submodule update && git submodule foreach git pull && nix flake update"


            echo -e "You can apply this flake to your system with \e[1mrebuild\e[0m"
            echo -e "And update it with \e[1mupdate\e[0m"
            echo -e "And apply user configuration with \e[1musrbuild\e[0m and system configuration with \e[1msysbuild\e[0m"
            echo -e "\n"
            echo -e "update = \e[1mnix flake update\e[0m"
            echo -e "usrbuild = \e[1mhome-manager switch --flake .\e[0m"
            echo -e "sysbuild = \e[1m nixos-rebuild switch --use-remote-sudo --flake .\e[0m"
            echo -e "rebuild = \e[1msysbuild && usrbuild\e[0m"
            PATH=${pkgs.writeShellScriptBin "nix" ''
                    ${pkgs.nixFlakes}/bin/nix --experimental-features "nix-command flakes" "$@"
            eval "$(${pkgs.direnv}/bin/direnv hook bash)"
            ${pkgs.direnv}/bin/direnv allow
                ''}/bin:$PATH
          '';
          # nativeBuildInputs = with pkgs; [
          # ];
        };
    };
}
