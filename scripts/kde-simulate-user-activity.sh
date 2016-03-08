#!/bin/sh
# Simple script to demonstrate D-Bus usage
# Simulate user activity when Google Chrome use more then 5% CPU

while true
do
  # read google chrome cpu usage
  ret=`top -b -n1 -u $(whoami) | awk '$12 ~ /chrome/ {SUM += $9} END {print SUM}'`

  if [ -n "$ret" ] && [ "$ret" -gt 5 ]; then
    idle_time=`qdbus org.kde.screensaver /ScreenSaver GetSessionIdleTime`
    if [ "$idle_time" -gt 50 ]; then
      qdbus org.kde.screensaver /ScreenSaver SimulateUserActivity
    fi
  fi

  sleep 50
done
