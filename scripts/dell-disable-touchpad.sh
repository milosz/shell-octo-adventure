#!/bin/sh
# Shell script used to to disable/enable touchpad on Dell XPS 13 using single keyboard shortcut
# Source: https://blog.sleeplessbeastie.eu/2016/07/11/how-to-disable-touchpad-using-keyboard-shortcut/

# get device id
device_id="$(xinput list | sed  -ne '/DLL0665:01 06CB:76AD Touchpad/ s/.*id=\([0-9]*\).*/\1/p')"

if [ -n "${device_id}" ]; then
  # verify current state, set action
  check_state=$(xinput list ${device_id} --long | grep "This device is disabled")
  if [ -n "${check_state}" ]; then
    action="enable"
  else
    action="disable"
  fi

  # execute action
  xinput ${action} ${device_id}
fi
