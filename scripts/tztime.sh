#!/bin/sh
# Print time in different timezones
#
# Output:
# $ sh tztime.sh 
# Europe/Warsaw    : 15/11/10 00:31:09
# Europe/Britain   : 14/11/10 23:31:09
# America/Chicago  : 14/11/10 17:31:09

# TZ
timezones="Europe/Warsaw Europe/Britain America/Chicago"

# Locale
locale="pl_PL.UTF8"

for tz in $timezones; do
  datetime=`LC_ALL=${locale} TZ=${tz} date +"%d/%m/%y %T"`
  printf "%-16s : %s\n" "${tz}" "${datetime}"
done
