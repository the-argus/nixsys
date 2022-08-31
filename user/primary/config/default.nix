{ pkgs, ... }: {
  imports = [
    ./nvim
    ./ranger
    ./neofetch
    ./qtile
    ./rofi
  ];

  home.file.".xinitrc".text = ''
    #!/bin/sh

    userresources=$HOME/.Xresources
    usermodmap=$HOME/.Xmodmap
    sysresources=${pkgs.xorg.xinit}/etc/X11/xinit/.Xresources
    sysmodmap=${pkgs.xorg.xinit}/etc/X11/xinit/.Xmodmap

    # merge in defaults and keymaps

    if [ -f $sysresources ]; then
        xrdb -merge $sysresources
    fi

    if [ -f $sysmodmap ]; then
        xmodmap $sysmodmap
    fi

    if [ -f "$userresources" ]; then
        xrdb -merge "$userresources"
    fi

    if [ -f "$usermodmap" ]; then
        xmodmap "$usermodmap"
    fi

    # start some nice programs

    if [ -d ${pkgs.xorg.xinit}/etc/X11/xinit/xinitrc.d ] ; then
     for f in ${pkgs.xorg.xinit}/etc/X11/xinit/xinitrc.d/?*.sh ; do
      [ -x "$f" ] && . "$f"
     done
     unset f
    fi

    PYTHONDONTWRITEBYTECODE="yes" exec qtile start
  '';
}
