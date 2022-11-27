{pkgs, ...}: {
  imports = [
    ./ranger
    ./neofetch
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

    # supplied by pkgs.dbus
    dbus-update-activation-environment --systemd DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY

    if [[ $1 == "i3gaps" ]]; then
        exec i3
    elif [[ $1 == "qtile" ]]; then
        PYTHONDONTWRITEBYTECODE="yes" GTK_USE_PORTAL=0 exec qtile start
    elif [[ $1 == "awesome" ]]; then
        exec awesome
    elif [[ $1 == "ratpoison" ]]; then
        exec ratpoison
    else
        # default to qtile
        PYTHONDONTWRITEBYTECODE="yes" GTK_USE_PORTAL=0 exec qtile start
    fi
  '';
}
