#!/bin/sh
# Update battery charge level
# Description: http://blog.sleeplessbeastie.eu/2013/01/02/debian-how-to-monitor-battery-capacity/

rrd_file="/home/milosz/.battery/battery_capacity.rrd"

charge_now=`cat /sys/class/power_supply/BAT0/charge_now` 
charge_now=`expr ${charge_now} / 1000`

rrdtool update ${rrd_file} N:${charge_now}

