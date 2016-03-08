#!/bin/sh
# print how much data has been written to the file or device
# dd output will overwrite printed data at the end
#
# sample usage:
# dd.sh if=infile of=outfile

# execute dd command in the background
$(which dd) $* &

# read process ID
process=$!

# execute until the process exists
while [ "$(kill -0 $process 2>/dev/null; echo $?)" -eq "0" ]; do
  if [ -e "/proc/${process}/io" ]; then
    # get number of written bytes
    written_data=$(cat /proc/${process}/io | awk '/wchar/ {print $2}')

    # convert it to human readable form
    unit="B"                                     # bytes

    if [ "$written_data" -gt "1024" ]; then
      written_data=$(expr $written_data / 1024)  # kilobytes
      unit="KB"
    fi

    if [ "$written_data" -gt "1024" ]; then
      written_data=$(expr $written_data / 1024)  # megabytes
      unit="MB"
    fi

    if [ "$written_data" -gt "1024" ]; then
      written_data=$(expr $written_data / 1024)  # gigabytes
      unit="GB"
    fi

    if [ "$written_data" -gt "1024" ]; then
      written_data=$(expr $written_data / 1024)  # terabytes
      unit="TB"
    fi

    # print output
    printf "%4s %2s\r" ${written_data} ${unit}

    # wait 1 second
    sleep 1
  else
    break
  fi
done
