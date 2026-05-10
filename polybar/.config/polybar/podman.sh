#!/bin/bash

output=$(podman ps -a --format "{{.State}}" 2>/dev/null)

if [ -z "$output" ]; then
    echo " 󰡨  0 "
else
    total=$(echo "$output" | wc -l)
    running=$(echo "$output" | grep -c "running")
    echo " 󰡨  ${running}/${total} "
fi
