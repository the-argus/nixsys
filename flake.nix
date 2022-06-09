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
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ranger-devicons = {
      url = "github:alexanderjeurissen/ranger_devicons";
      flake = false;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    kanagawa-gtk = {
      url = "github:Fausto-Korpsvart/Kanagawa-GKT-Theme";
      flake = false;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    arkenfox-userjs = {
      url = "github:arkenfox/user.js";
      flake = false;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    picom = {
      url = "github:Arian8j2/picom-jonaburg-fix";
      flake = false;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    awesome = {
      url = "github:awesomeWM/awesome";
      flake = false;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs.overlays = [
        (self: super: 
        {
            awesome = super.awesome.overrideAttrs (old: {src = awesome;});
        })
        (self: super: 
        {
            picom = super.picom.overrideAttrs (old: {src = picom;});
        })
    ];
  };

  outputs = { self, nixpkgs, home-manager, nur, nvim-config, ranger-devicons, kanagawa-gtk, arkenfox-userjs, picom, awesome, ... }@inputs:
    let
      system = "x86_64-linux";
      username = "argus";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      nixosConfigurations = {
        # hostname (evil)
        evil = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = inputs;
          modules = [
            ./system/configuration.nix
          ];
        };
      };

      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit system username;
        homeDirectory = "/home/${username}";
        configuration = import ./user/${username};
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
