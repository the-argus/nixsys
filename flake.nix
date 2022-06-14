{
  description = "the-argus nixos system configuration";

  inputs = {
    #nixpkgs.url = "nixpkgs/nixos-21.11";
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      # home manager use out nixpkgs and not its own
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvim-config = {
      url = "github:the-argus/nvim-config";
      flake = false;
    };

    ranger-devicons = {
      url = "github:alexanderjeurissen/ranger_devicons";
      flake = false;
    };

    kanagawa-gtk = {
      url = "github:Fausto-Korpsvart/Kanagawa-GKT-Theme";
      flake = false;
    };

    rose-pine-gtk = {
      url = "github:rose-pine/gtk";
      flake = false;
    };

    arkenfox-userjs = {
      url = "github:arkenfox/user.js";
      flake = false;
    };

    picom = {
      url = "github:Arian8j2/picom-jonaburg-fix";
      flake = false;
    };

    awesome = {
      url = "github:awesomeWM/awesome";
      flake = false;
    };

    spicetify-nix = {
      url = "github:the-argus/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-themes = {
      url = "github:morpheusthewhite/spicetify-themes";
      flake = false;
    };

    # font-icons = {
    #   url = "git+https://aur.archlinux.org/ttf-font-icons";
    #   flake = false;
    # };
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , nur
    , nvim-config
    , ranger-devicons
    , arkenfox-userjs
    , kanagawa-gtk
    , rose-pine-gtk
    , picom
    , awesome
    , spicetify-nix
    , spicetify-themes
    , # font-icons,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      username = "argus";
      pkgs = import nixpkgs { inherit system; };

      overlays = [
        (self: super: {
        # better discord performance, if its not installed via flatpak
          discord = super.discord.override {
            commandLineArgs =
              "--no-sandbox --enable-accelerated-mjpeg-decode --enable-accelerated-video --ignore-gpu-blacklist --enable-native-gpu-memory-buffers --enable-gpu-rasterization";
          };
        })
      ];
    in
    {
      nixosConfigurations = {
        # hostname (evil)
        evil = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = inputs;
          modules = [
            {
                nixpkgs.overlays = overlays;
                imports = [ ./system/configuration.nix ];
            }
          ];
        };
      };

      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit system username;
        homeDirectory = "/home/${username}";
        configuration = {pkgs, ...}: {
            imports = [ ./user/${username} ];
            nixpkgs.overlays = overlays;
        };
        stateVersion = "22.05";
        extraSpecialArgs = inputs;
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
                ''}/bin:$PATH
          '';
          # nativeBuildInputs = with pkgs; [
          # ];
        };
    };
}
