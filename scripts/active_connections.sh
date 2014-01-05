#!/bin/sh
# Print established TCP connections

printf "%-15.15s %5s %20s %7.7s\n" "Process" "PID" "Destination IP" "Port"&& ss  -o state established -t -p  | \
sed -e 1d -e 's/[0-9]*[\ ]\{2,10\}[0-9]*[\ ]\{2,20\}.*:[0-9]*[\ ]\{2,20\}\(.*\):\(.*\)[\ ]\{2,20\}.*:(("\(.*\)",\(.*\),[0-9]*))/\3\t\4\t\1\t\2/g' | \
awk '{printf "%-15.15s %5s %20s %7.7s\n",$1,$2,$3,$4}'
