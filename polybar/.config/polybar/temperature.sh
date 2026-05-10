#!/usr/bin/env bash

# Find CPU temperature sensor (coretemp/k10temp/zenpower)
for hwmon in /sys/class/hwmon/hwmon*; do
    name=$(cat "$hwmon/name" 2>/dev/null)
    case "$name" in
        coretemp|k10temp|zenpower)
            # Prefer Tctl/Tdie/Package on AMD/Intel; fall back to temp1
            for label_file in "$hwmon"/temp*_label; do
                [ -f "$label_file" ] || continue
                label=$(cat "$label_file")
                case "$label" in
                    Tctl|Tdie|"Package id 0")
                        input="${label_file%_label}_input"
                        break 2
                        ;;
                esac
            done
            input="$hwmon/temp1_input"
            break
            ;;
    esac
done

[ -z "${input:-}" ] || [ ! -f "$input" ] && exit 0

temp=$(($(cat "$input") / 1000))

# Warn threshold
if [ "$temp" -ge 80 ]; then
    printf "%%  %d°C %%{F-}" "$temp"
else
    printf "  %d°C " "$temp"
fi
