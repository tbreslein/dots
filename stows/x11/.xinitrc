# Statusbar loop for dwm
if [[ "$X11_WM" == "dwm" ]]; then
    while true; do
       xsetroot -name "$( date +"%F %R" )"
       sleep 30    # Update time every minute
    done &
fi

# autostarts
if [[ ! "$X11_WM" == "awesome" ]]; then
    dunst &
    picom -b
    nm-applet &
    redshift -l "54.8:9.4"
    xautolock -time 10 -locker slock
    [ -f /home/tommy/.fehbg ] && /home/tommy/.fehbg
    #blueman-applet
fi

exec /home/tommy/.local/bin/startwm
