## autostarts
#if [[ ! "$X11_WM" == "awesome" ]]; then
#    dunst &
#    picom -b
#    nm-applet &
#    redshift -l "54.8:9.4"
#    xautolock -time 10 -locker slock
#    [ -f /home/tommy/.fehbg ] && /home/tommy/.fehbg
#    #blueman-applet
#fi
#


/home/tommy/.local/bin/dm/refresh_env
source /home/tommy/.local/bin/dm/.env

xrdb ~/.Xresources
if [[ "$_HOST" == "moebius" ]]; then
    xrandr --output DP-1 --mode 3840x2160 --rate 144 --scale 0.75
fi

if [[ "$X11_WM" == "awesome" ]]; then
    exec awesome
elif [[ "$X11_WM" == "dwm" ]]; then
    while true; do
       xsetroot -name "$( date +"%F %R" )"
       sleep 30    # Update time 30 seconds
    done &
    exec dwm
elif [[ "$X11_WM" == "qtile" ]]; then
    exec qtile
elif [[ "$X11_WM" =~ "i3" ]]; then
    exec i3wm
else
    echo "WARNING! \$X11_WM is set to an invalid value: $X11_WM"
    exit 1
fi
