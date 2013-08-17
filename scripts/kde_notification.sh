#!/bin/sh
# Simple shell script to display KDE notification

message(){
cat << EOF
Say <strong>hello</strong> using your <font color=red>nofication</font> area.
Date: `date`
Used space: `df -h | grep sda1 | awk '{ print $5 }'`
Load average: <u>`uptime | awk '{ print $10 $11 $12 }' | sed s/\,/\ /g`</u>
EOF
}

timeout=20
kdialog=`which kdialog`

${kdialog} --passivepopup "`message`" ${timeout}
