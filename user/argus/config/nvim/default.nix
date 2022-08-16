{ pkgs, nvim-config, ... }: {
  home.file = {
    ".config/nvim" = {
      source = nvim-config;
      recursive = true;
    };

    ".config/nvim/lua/color-override.lua".text = 
    let
        p = (pkgs.callPackage ../../themes.nix {}).scheme;
    in with p;
    ''
      local palette = {
          base = '#${p.bg}00',
          surface = '#${altbg2}',
          overlay = '#${altfg2}',
          muted = '#${black}',
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
  };
}
