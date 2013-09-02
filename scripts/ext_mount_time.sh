#!/bin/sh
# print last mount time of the ext2/ext3/ext4 filesystems
#
# Description: http://blog.sleeplessbeastie.eu/2013/09/03/how-to-check-last-mount-time-of-the-ext2-ext3-ext4-filesystem/
#
# contact:
# milosz@sleeplessbeastie.eu
#

if [ "$(whoami)" = "root" ]; then
  mount | \
   awk '/dev.*ext/ {print $1}' | \
   xargs -I DEVICE sh -c '{ mount | grep DEVICE | \
   awk "{ print \"----- device \" \$1 \" mounted on \" \$3 }"; \
    tune2fs -l DEVICE | grep "Last\|created"; }'
fi
