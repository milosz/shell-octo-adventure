#!/bin/sh
# List virtual machines and their corresponding states

VBoxManage list vms -l | grep -e ^Name: -e ^State  | sed "s/Name:[ ]*\(.*\)/\1 \//;s/State:[\ ]*//" | paste -d " " - -
