#!/bin/sh
# Reboot Linksys WAG120N router

username="admin"
password="password"

address="http://192.168.1.1"

wget -O /dev/null -nv --user \"$username\" --password \"$password\" ${address}/setup.cgi?todo=reboot
