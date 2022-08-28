{ pkgs, nvim-config, ... }: {
  home.file = with (pkgs.callPackage ../../themes.nix { }).scheme; {
    ".config/nvim" = 
      let
        text = ''
          local palette = {
              base = '#${terminal.bg}00',
              surface = '#${altbg2}',
              overlay = '#${altfg2}',
              muted = '#${terminal.black}',
              subtle = '#${altfg3}',
              text = '#${white}',
              love = '#${red}',
              gold = '#${yellow}',
              rose = '#${cyan}',
              pine = '#${blue}',
              foam = '#${green}',
              iris = '#${magenta}',
              highlight_low = '#${altbg}',
              highlight_med = '#${altbg3}',
              highlight_high = '#${altbg3}',
              opacity = 0.1,
              none = 'NONE',
          }

          return palette
        '';
        override = builtins.toFile "color-override.lua" text;

        overridenConfig = pkgs.stdenv.mkDerivation {
            name = "overriden-neovim-config";
            src = nvim-config;
            buildPhase = ''
                cp ${override} lua/color-override.lua
                ${pkgs.coreutils-full}/bin/chmod -R a+wr .
            '';
            installPhase = "cp -r . $out";
        };
      in
    {
      source = overridenConfig;
      recursive = true;
    };
  };
}
