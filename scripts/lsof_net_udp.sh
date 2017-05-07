#!/bin/bash
# Display UDP connections
# Commands: sudo, lsof, gawk, sort
# Source: https://blog.sleeplessbeastie.eu/2017/05/29/how-to-display-network-connections-using-lsof-and-gnu-awk/

sudo lsof -iUDP -P -n | \
     sed 1d | \
     gawk '{
       split($9,address,"->");
       if (substr(address[1],1,1) != "[") {
         split(address[1],local,":");
       } else {
         local[1]=gensub(/\[(.*)\]:.*/,"\\1","g",address[1]);
         local[2]=gensub(/\[.*\]:(.*)/,"\\1","g",address[1]);
       };
       if (substr(address[2],1,1) != "[") {
         split(address[2],remote,":");
       } else {
         remote[1]=gensub(/\[(.*)\]:.*/,"\\1","g",address[2]);
         remote[2]=gensub(/\[.*\]:(.*)/,"\\1","g",address[2]);
       };
       local_address="local address " $5 " " local[1] " port " local[2];
       if (length(remote[1])>0) {
         remote_address="remote address " remote[1] " port " remote[2];
       } else {
         remote_address="";
       }
       cmd="cat /proc/" $2 "/cmdline | tr '\''\\000'\'' '\'' '\''"; 
       cmd | getline output; 
       close(cmd);
       printf "Process %5s %s %s -- %s \n",$2,local_address,remote_address, output;
     }' | \
     sort

