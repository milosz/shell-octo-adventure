#!/bin/sh
# Determine file system type on device
# Source: https://blog.sleeplessbeastie.eu/2016/01/11/how-to-determine-file-system-type/

specified_device=$1

if [ -n "$specified_device" ]; then
  devices=$(lsblk -P -o NAME,FSTYPE $specified_device)
  for device in $devices; do

    eval $device

    if [ -n "$FSTYPE" ]; then
      #echo $NAME - $FSTYPE
      printf "%-30s %15s\n" "$NAME" "$FSTYPE"
    fi
  done
fi
