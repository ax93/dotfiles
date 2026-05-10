#!/bin/bash

DEVICES=$(nmcli -t -f DEVICE,STATE device | grep ":connected" | grep -v "^lo:" | cut -d: -f1)

if [ -z "$DEVICES" ]; then
    echo " Disconnected    "
    exit 0
fi

OUTPUT=""
VPN_ACTIVE=false

if nmcli -t -f TYPE,STATE connection show --active | grep -q "wireguard:activated"; then
    VPN_ACTIVE=true
fi

for DEVICE in $DEVICES; do
    TYPE=$(nmcli -t -f DEVICE,TYPE device | grep "^$DEVICE:" | cut -d: -f2)
    IP=$(nmcli -t -f IP4.ADDRESS device show "$DEVICE" | head -n1 | cut -d: -f2 | cut -d/ -f1)
    
    if [ "$TYPE" = "ethernet" ]; then
        INFO="  $DEVICE $IP"
    elif [ "$TYPE" = "wifi" ]; then
        SSID=$(nmcli -t -f CONNECTION device show "$DEVICE" | grep "GENERAL.CONNECTION" | cut -d: -f2)
	INFO="󰖩  $SSID $IP"
    elif [ "$TYPE" = "wireguard" ]; then
	VPN_NAME=$(nmcli -t -f GENERAL.CONNECTION device show "$DEVICE" | cut -d: -f2 | xargs)
        INFO="  $VPN_NAME ($IP)"
    else
        INFO=" $DEVICE $IP "
    fi
    
    if [ -z "$OUTPUT" ]; then
        OUTPUT="$INFO"
    else
        OUTPUT="$OUTPUT | $INFO "
    fi
done

if [ "$VPN_ACTIVE" = false ]; then
   OUTPUT="$OUTPUT | %{F#f00}VPN DOWN%{F-} "
fi 

echo "$OUTPUT"
