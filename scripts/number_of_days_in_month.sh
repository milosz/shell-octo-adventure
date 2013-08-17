#!/bin/sh
# Display number of days in a month

echo "Number of days in a month"

echo -n "Current month: "
cal $(date +"%m %Y") | awk 'NR==1 {MON_YEAR=$1 " " $2};NF {DAYS = $NF}; END {print MON_YEAR " - " DAYS}'

echo -n "Next month: "
cal $(date +"%m %Y" --date "next month") | awk 'NR==1 {MON_YEAR=$1 " " $2};NF {DAYS = $NF}; END {print MON_YEAR " - " DAYS}'
