#!/bin/sh
# Determine when daylight saving time changes

if [ -f "/etc/timezone" ]; then
  zdump -v $(cat /etc/timezone) | grep $(date +%Y)
fi
