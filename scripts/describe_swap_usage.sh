#!/bin/bash
# Display processes using swap space
#
# Source: https://blog.sleeplessbeastie.eu/2016/12/26/how-to-display-processes-using-swap-space/
#

printf "%10s %-30s %20s\n" "PID" "Process name" "Swap usage"
find /proc -maxdepth 2 -path "/proc/[0-9]*/status" -readable -exec \
  awk -v FS=":" '{process[$1]=$2;sub(/^[ \t]+/,"",process[$1]);} END {if(process["VmSwap"] && process["VmSwap"] != "0 kB") printf "%10s %-30s %20s\n",process["Pid"],process["Name"],process["VmSwap"]}' '{}' \; | \
  awk '{print $(NF-1),$0}' | \
  sort -hr | \
  cut -d " " -f2-

