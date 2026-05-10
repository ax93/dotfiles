#!/usr/bin/env bash

chosen=$(printf " 󰐥 shutdown\n 󰜉 reboot\n 󰍃 logout" \
    | rofi -dmenu \
           -theme ~/.config/rofi/powermenu.rasi \
           -no-show-icons)

case "$chosen" in
    *shutdown) systemctl poweroff ;;
    *reboot)   systemctl reboot ;;
    *logout)   i3-msg exit ;;
esac
