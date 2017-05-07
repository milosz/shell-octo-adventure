#!/bin/bash
# Display listening TCP ports
# Commands: sudo, lsof, gawk, sort
# Source: https://blog.sleeplessbeastie.eu/2017/05/29/how-to-display-network-connections-using-lsof-and-gnu-awk/

sudo lsof -iTCP -sTCP:LISTEN -P -n | \
     sed 1d | \
     gawk '{ 
         if (substr($9,1,1) != "[") {
           split($9,local,":");
         } else {
           local[1]=gensub(/\[(.*)\]:.*/,"\\1","g",$9);
           local[2]=gensub(/\[.*\]:(.*)/,"\\1","g",$9);
         };
         cmd="cat /proc/" $2 "/cmdline | tr '\''\\000'\'' '\'' '\''"; 
         cmd | getline output; 
         close(cmd);
         printf "Process %5s is listening on %s %s port %s -- %s \n",$2,$5,local[1],local[2],output
       }' | \
       sort

