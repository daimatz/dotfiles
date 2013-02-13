#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# exec gnome-session
# exec startkde
# exec startxfce4
# ...or the Window Manager of your choice

export XIM=ibus
export XIM_PROGRAM=/usr/bin/ibus-daemon
export XIM_ARGS="--xim"
export XMODIFIERS="@im=ibus"
export GTK_IM_MODULE="ibus"
export QT_IM_MODULE="xim"
ibus-daemon --xim -d &

export VDPAU_NVIDIA_NO_OVERLAY=1 # for flash

xset -b

xmodmap ~/.Xmodmap

exec ck-launch-session dbus-launch startkde
