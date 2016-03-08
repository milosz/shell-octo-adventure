#!/bin/sh
# Simple shell script to start VNC service on display :0
# for *milosz* user using password stored in *~/.vnc/passwd*
# and listen on *192.168.32.5* IP address
# https://blog.sleeplessbeastie.eu/2014/12/02/how-to-automatically-share-x-session-using-vnc/

if [ "$(whoami)" = "milosz" ]; then
  x11vnc -display :0 -rfbauth ~/.vnc/passwd -listen 192.168.32.5 -ncache 10 -forever &
fi
