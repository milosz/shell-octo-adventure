#!/bin/sh
# Determine boot time

date --date "now - `cut -d ' ' -f 1 /proc/uptime` seconds"
