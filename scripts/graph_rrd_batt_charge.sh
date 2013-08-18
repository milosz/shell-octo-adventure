#!/bin/sh
# Create "battery charge level" graphs for 1 day, 1 week and 1 month
# Description: http://blog.sleeplessbeastie.eu/2013/01/02/debian-how-to-monitor-battery-capacity/

rrd_file="/home/milosz/.battery/battery_capacity.rrd"
destination="/home/milosz/.battery/"

for period in "1d" "1w" "1m"
do
  /usr/bin/rrdtool graph - \
    --imgformat=PNG -N  \
    --start=-${period} \
    --end=-60 \
    --title="Battery capacity - ${period}" \
    --rigid \
    --base=1000 \
    --full-size-mode \
    --height=210 \
    --width=590 \
    --upper-limit=6000 \
    --lower-limit=0 \
    --vertical-label="mAh" \
    --slope-mode \
    --border 0 \
    --color BACK#FFFFFF \
    --color GRID#FFFFFF \
    --color MGRID#FFFFFF \
    DEF:a=${rrd_file}:capacity:MAX \
    HRULE:5856#FF0000:"Maximum battery capacity" \
    CDEF:b=a,UN,PREV,a,IF \
    LINE:b#dddddd \
    LINE:a#000FF0FF:"Battery capacity" > ${destination}battery_charge_level_${period}.png
done
