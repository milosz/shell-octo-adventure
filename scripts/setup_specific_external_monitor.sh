#!/bin/sh
# Automatically setup external monitor
# Description: http://blog.sleeplessbeastie.eu/2013/01/07/how-to-automatically-set-up-external-monitor/


xrandr_command=`which xrandr`
sed_command=`which sed`
edid_command=`which parse-edid`
awk_command=`which awk`

is_hdmi_connected=`DISPLAY=:0 $xrandr_command | $sed_command -n '/HDMI1 connected/p'`
if [ -n "$is_hdmi_connected" ]; then
  # Read vendor
  vendor=`$edid_command /sys/devices/pci0000:00/0000:00:02.0/drm/card0/card0-HDMI-A-1/edid 2>/dev/null | $awk_command -F '"' '/VendorName/ {print $2}'`
  # Read model
  model=`$edid_command /sys/devices/pci0000:00/0000:00:02.0/drm/card0/card0-HDMI-A-1/edid 2>/dev/null | $awk_command -F '"' '/ModelName/ {print $2}'`

  if [ -n "$model" ] && [ -n "$vendor" ]; then
    if [ "$model" = "PANASONIC-TV" ] && [ "$vendor" = "MEI" ]; then
      # Panasonic TV - right of the internal LCD
      DISPLAY=:0 $xrandr_command --output HDMI1 --auto --right-of LVDS1
    elif [ "$model" = "SyncMaster" ] && [ "$vendor" = "SAM" ]; then
      # Samsung SyncMaster - left of the internal LCD
      DISPLAY=:0 $xrandr_command --output HDMI1 --auto --left-of LVDS1
    fi
  else
    # Default - above the internal LCD
    DISPLAY=:0 $xrandr_command --output HDMI1 --auto --above LVDS1
  fi
else
  DISPLAY=:0 $xrandr_command --output HDMI1 --off
fi
