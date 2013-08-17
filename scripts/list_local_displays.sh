#!/bin/sh
# List local displays

# X sockets directory
directory="/tmp/.X11-unix"

for file in ${directory}/*; do
  # translate file to display
  display=`echo "$file" | sed -e "s|${directory}/X|:|"`

  if [ "$(id -u)" -ne "0" ]; then
    # not root - show display
    echo $display;
  else
    # root - show display, process name and process id
    for line in `lsof "$file" | awk 'NR>1 {print $1 "/" $2}'`; do
      echo $display $line
    done
  fi
done
