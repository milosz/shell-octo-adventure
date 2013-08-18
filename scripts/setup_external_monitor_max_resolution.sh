#!/bin/sh
# Automatically setup external monitor using max resolution
# Description: http://blog.sleeplessbeastie.eu/2013/01/07/how-to-automatically-set-up-external-monitor/

xrandr_command="/usr/bin/xrandr"
awk_command="/bin/awk"

resolution=`${xrandr} | $awk_command '/HDMI1 connected/ { getline; print  $1 }'`

if [ -n "$resolution" ]; then
  DISPLAY=:0 $xrandr_command --output HDMI1 --mode $resolution --above LVDS1 
else
  DISPLAY=:0 $xrandr_command --output HDMI1 --off
fi

