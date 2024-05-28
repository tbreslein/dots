# Statusbar loop
while true; do
   xsetroot -name "$( date +"%F %R" )"
   sleep 30    # Update time every minute
done &

# autostarts
dunst &
picom -b
nm-applet &
redshift -l "54.8:9.4"
xautolock -time 10 -locker slock
[ -f /home/tommy/.fehbg ] && /home/tommy/.fehbg
#blueman-applet

exec /home/tommy/.local/bin/startwm
