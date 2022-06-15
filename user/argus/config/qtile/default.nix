{ pkgs, picom, ... }: {
  home.file = 
let
    picomPkg = import ../../../../packages/picom.nix
        { inherit pkgs; inherit picom;}; 

    laptopAutostart = ''
# laptop has bluetooth and wireless
${pkgs.blueman}/bin/blueman-applet &
${pkgs.network-manager-applet}/bin/nm-applet &
    '';

    pcAutostart = ''
# i use a mouse on my pc, so theres middleclick
${pkgs.xmousepasteblock}/bin/xmousepasteblock &
    '';
in
  {
    ".config/qtile" = {
      source = ./config;
      recursive = true;
    };

    ".config/qtile/autostart.sh".text = ''
#!/bin/sh

${pkgs.dunst}/bin/dunst &
${pkgs.xfce4-clipman-plugin}/bin/xfce4-clipman &
${pkgs.xsuspender}/bin/xsuspender &
${pkgs.xclip}/bin/xclip &

# start picom fr
# ${picomPkg}/bin/picom --config ~/.config/qtile/config/picom.conf &

# start picom IF we have it installed
picom --config ~/.config/qtile/config/picom.conf &

# restore feh wallpaper
$HOME/.fehbg
    '';
  };
}
