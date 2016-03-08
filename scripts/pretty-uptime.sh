#!/bin/sh
# pretty-print system uptime

# get number of seconds
seconds_uptime=$(awk '{print int($1)}' /proc/uptime)

# calculate seconds for each time period
seconds_in_year=$(  echo "(365.2425  * 24 * 60 * 60)/1" | bc)
seconds_in_month=$( echo "(30.436875 * 24 * 60 * 60)/1" | bc)
seconds_in_day=$(   echo "(            24 * 60 * 60)/1" | bc)
seconds_in_hour=$(  echo "(                 60 * 60)/1" | bc)
seconds_in_minute=60

# take care of years
if [ "$seconds_uptime" -ge "$seconds_in_year" ]; then
  years=$(expr $seconds_uptime \/ $seconds_in_year)
  seconds_uptime=$(expr $seconds_uptime - $years \* $seconds_in_year)
  if [ "$years" -gt "1" ]; then 
    echo -n "$years years "
  elif [ "$years" -eq "1" ]; then 
    echo -n "$years year "
  fi
fi

# take care of months
if [ "$seconds_uptime" -ge "$seconds_in_month" ]; then
  months=$(expr $seconds_uptime \/ $seconds_in_month)
  seconds_uptime=$(expr $seconds_uptime - $months \* $seconds_in_month)
  if [ "$months" -gt "1" ]; then
    echo -n "$months months "
  elif [ "$months" -eq "1" ]; then
    echo -n "$months month "
  fi
fi

# take care of days
if [ "$seconds_uptime" -ge "$seconds_in_day" ]; then
  days=$(expr $seconds_uptime \/ $seconds_in_day)
  seconds_uptime=$(expr $seconds_uptime - $days \* $seconds_in_day)
  if [ "$days" -gt "1" ]; then
    echo -n "$days days "
  elif [ "$days" -eq "1" ]; then
    echo -n "$days day "
  fi
fi

# take care of hours
if [ "$seconds_uptime" -ge "$seconds_in_hour" ]; then
  hours=$(expr $seconds_uptime \/ $seconds_in_hour)
  seconds_uptime=$(expr $seconds_uptime - $hours \* $seconds_in_hour)
  if [ "$hours" -gt "1" ]; then
    echo -n "$hours hours "
  elif [ "$hours" -eq "1" ]; then
    echo -n "$hours hour "
  fi
fi

# take care of minutes
if [ "$seconds_uptime" -ge "$seconds_in_minute" ]; then
  minutes=$(expr $seconds_uptime \/ $seconds_in_minute)
  seconds_uptime=$(expr $seconds_uptime - $minutes \* $seconds_in_minute)
  if [ "$minutes" -gt "1" ]; then
    echo -n "$minutes minutes "
  elif [ "$minutes" -eq "1" ]; then
    echo -n "$minutes minute "
  fi
fi

# take care of seconds
seconds=$seconds_uptime
if [ "$seconds" -gt "1" ]; then
  echo -n "$seconds seconds "
elif [ "$seconds" -eq "1" ]; then
  echo -n "$seconds second "
fi

# go to the next line
echo
