#!/usr/bin/env zsh

run() {
    if ! pgrep -f "$1"; then
        "$@" &
    fi
}

run "picom" "-b"
run "nm-applet"
run "redshift" "-l 54.8:9.4"
run "xautolock" "-time 10" "-locker slock"
