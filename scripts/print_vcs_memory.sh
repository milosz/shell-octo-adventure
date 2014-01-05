#!/bin/sh
# Print contents of the virtual console terminals
#
# Note: Use sudo to execute this shell script

# wrap each input line to fit in specified width
width=170

for i in $(seq 1 63)
do
  device="/dev/vcs${i}"
  if [ -c "$device" ]; then
    echo "------ $device"
    cat $device | fold --width ${width} | sed -e 's/ *$//g' | sed -e '/^$/N;/\n$/d' | sed -e '${G}'
    echo
  fi
done
