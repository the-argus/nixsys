{
  pkgs,
  nvim-config,
  config,
  ...
}: {
  home.file = with config.system.theme.scheme; {
    ".config/nvim" = let
      text = ''
        local palette = {
            base = '#${base00}00',
            surface = '#${base02}',
            overlay = '#${base02}',
            muted = '#${base00}',
            subtle = '#${base03}',
            text = '#${white}',
            love = '#${base09}',
            gold = '#${base0A}',
            rose = '#${base0B}',
            pine = '#${base0C}',
            foam = '#${base0D}',
            iris = '#${base0E}',
            highlight_low = '#${base01}',
            highlight_med = '#${base03}',
            highlight_high = '#${base03}',
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
    in {
      source = overridenConfig;
      recursive = true;
    };
  };
}
