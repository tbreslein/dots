#!/usr/bin/env bash

sleep 1
pkill '^xdg-desktop-portal*'
sleep 1
/usr/lib/xdg-desktop-portal-hyprland &
sleep 2
/usr/lib/xdg-desktop-portal &
sleep 1
