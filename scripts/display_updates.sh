#!/bin/sh
# Debian - Display available updates
# More information: http://blog.sleeplessbeastie.eu/2013/07/29/debian-how-to-display-available-updates/

apt-get -s dist-upgrade | sed -r -n -e "s/^Inst (.*) \[(.*)\] \((.*) .* \[(.*)\]\).*/\1 \2 \3 \4/p" | sort | awk -F\  '{ printf "%7s\t%-25s %25s -> %-25s\n", $4, $1, $2, $3 }'
