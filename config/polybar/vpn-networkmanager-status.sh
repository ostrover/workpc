#!/bin/sh

vpn="$(nmcli -t -f name,type connection show --order name --active 2>/dev/null | grep wg | head -1 | cut -d ':' -f 1)"

if [ -n "$vpn" ]; then
	echo ""
else
	echo "󰅛 "
fi
