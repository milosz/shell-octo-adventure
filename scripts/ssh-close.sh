#!/bin/sh
# close every active ssh session
# source: https://blog.sleeplessbeastie.eu/2015/03/09/how-to-terminate-active-ssh-sessions/

lsof -w -t +d /dev/pts/ | sort | uniq | \
  xargs ps -oppid= -p | \
  xargs ps -ocomm=,pid=,user= -p | \
  awk '($1 == "sshd") {print $2}' | \
  xargs kill
