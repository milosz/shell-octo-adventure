#!/bin/bash
# Translate dmesg timestamps to human readable format
#
# Just in case 'dmest -T' is not supported

# desired date format
date_format="%a %b %d %T %Y"

# uptime in seconds
uptime=$(cut -d " " -f 1 /proc/uptime)

# run only if timestamps are enabled
if [ "Y" = "$(cat /sys/module/printk/parameters/time)" ]; then
  dmesg | sed "s/^\[[ ]*\?\([0-9.]*\)\] \(.*\)/\\1 \\2/" | while read timestamp message; do
    printf "[%s] %s\n" "$(date --date "now - $uptime seconds + $timestamp seconds" +"${date_format}")" "$message"
  done
else
  echo "Timestamps are disabled (/sys/module/printk/parameters/time)"
fi

