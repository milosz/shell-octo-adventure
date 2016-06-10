#!/bin/sh
# reset Intel Corporation Dual Band Wireless-AC 7265 on Dell XPS 13

# network interface name
interface="wlp2s0"

# syslog tag
tag="wifi-resume"

# check for "interface: link is not ready"
(dmesg | tail -10 | grep "${interface}: link is not ready")>/dev/null

if [ "$?" -eq 0 ]; then
    logger -t $tag "$interface is not ready"
    if [ -z "$(iwgetid --raw $interface)" ]; then
	logger -t $tag "$interface is not connected to any network"
	modprobe -r iwlwifi
	modprobe iwlwifi
    fi
    
fi    
