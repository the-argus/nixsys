{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell {
  name = "nixosbuildshell";
  nativeBuildInputs = with pkgs; [
    git
    git-crypt
    nixFlakes
  ];

  shellHook = ''
alias usrbuild="home-manager switch --flake ."
alias sysbuild="sudo nixos-rebuild switch --flake ."
alias rebuild="sysbuild && usrbuild"
alias update="nix flake update"


echo -e "You can apply this flake to your system with \e[1mrebuild\e[0m"
echo -e "And update it with \e[1mupdate\e[0m"
echo -e "And apply user configuration with \e[1musrbuild\e[0m and system configuration with \e[1msysbuild\e[0m"
echo -e "\n"
echo -e "update = \e[1mnix flake update\e[0m"
echo -e "usrbuild = \e[1mhome-manager switch --flake .\e[0m"
echo -e "sysbuild = \e[1msudo nixos-rebuild switch --flake .\e[0m"
echo -e "rebuild = \e[1msudo nixos-rebuild switch --flake . && home-manager switch --flake .\e[0m"
PATH=${pkgs.writeShellScriptBin "nix" ''
        ${pkgs.nixFlakes}/bin/nix --experimental-features "nix-command flakes" "$@"
    ''}/bin:$PATH
'';
}
