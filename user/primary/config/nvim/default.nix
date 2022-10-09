{
  pkgs,
  nvim-config,
  config,
  ...
}: {
  home.file.".config/nvim" = let
    color-override-text = with config.banner.palette; ''
      local palette = {
          base = '#${base00}00',
          surface = '#${base02}',
          overlay = '#${base02}',
          muted = '#${base04}',
          subtle = '#${base03}',
          text = '#${base05}',
          love = '#${base09}',
          gold = '#${base0A}',
          rose = '#${base0B}',
          pine = '#${base0C}',
          foam = '#${base0D}',
          iris = '#${base0E}',
          highlight_low = '#${base01}',
          highlight_med = '#${base03}',
          highlight_high = '#${base06}',
          opacity = 0.1,
          none = 'NONE',
      }

      return palette
    '';
    color-override = builtins.toFile "color-override.lua" color-override-text;

    overridenConfig = pkgs.stdenv.mkDerivation {
      pname = "overriden-neovim-config";
      version = "0.0.1";
      src = nvim-config;
      buildPhase = ''
        cp ${color-override} lua/color-override.lua
        ${pkgs.coreutils-full}/bin/chmod -R a+wr .
      '';
      installPhase = "cp -r . $out";
    };
  in {
    source = overridenConfig;
    recursive = true;
  };
}
