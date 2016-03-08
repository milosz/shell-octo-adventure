#!/bin/sh
# enter "https://" at the beginning of the address bar
# https://blog.sleeplessbeastie.eu/2013/01/21/how-to-automate-mouse-and-keyboard/

# used command
xte_command=`which xte`

if [ -n "$xte_command" ]; then
  # press F6, Home, enter "https://" string and press return
  $xte_command "sleep 1" "key F6" "usleep 10000" "key Home" "str https://" "key Return"
fi
