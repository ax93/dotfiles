#!/usr/bin/env bash

backlight_dir=$(find /sys/class/backlight -mindepth 1 -maxdepth 1 | head -n1)

if [ -z "$backlight_dir" ]; then
    exit 0
fi

current=$(cat "$backlight_dir/brightness")
max=$(cat "$backlight_dir/max_brightness")
percent=$(( current * 100 / max ))

printf " 󰖨 %d%% " "$percent"
