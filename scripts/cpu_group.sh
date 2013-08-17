#!/bin/sh
# Total CPU usage of the group of processes
# More information: http://blog.sleeplessbeastie.eu/2013/04/11/how-to-read-total-cpu-usage-of-the-group-of-processes/

export LC_ALL=C

if [ "$#" -eq "0" ]; then
  echo "Simple script to display total CPU usage of group of processes"
  echo "Usage:   $0 group1 group2 group3 ..."
  echo "Example: $0 ^k ako\|blue ^top$"
else
  for group in $*; do
    top_group=`top -b -n1 -u $(whoami) | awk "\\$12 ~ /$group/  {if (NR>=7) { print \\$0}}"`
    processes=`echo "$top_group" | awk '{print $12}' | sort | uniq`

    echo "Group: " $group
    for process in $processes; do
     process_escaped=`echo $process | sed 's/\//\\\\\//g'`
     process_cpu_usage=`echo "$top_group" | awk "/${process_escaped}/ {SUM += \\$9} END {printf \"%.1f%%\",SUM}"`
     printf "%20s %s\n" "$process" "$process_cpu_usage"
    done
    total_group_cpu=`echo "$top_group" | awk "{SUM += \\$9} END {printf  \"%.1f%%\",SUM}"`
    printf "%20s %s\n" "Group total" "$total_group_cpu"
  done
fi
