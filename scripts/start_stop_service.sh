#!/bin/sh
# start/stop service and create pid file for a non-daemon app

# service command
service_cmd="/opt/service/service"

# pid file location
service_pid="/var/run/service.pid"

if [ $# -eq 1 -a  "$1" = "start" ]; then
  if [ -f "$service_pid" ]; then
    kill -0 $(cat $service_pid) 2>/dev/null # check pid
    if [ $? -eq 0 ]; then
      exit 2; # process is running, exit
    else
      unlink $service_pid # process is not running
                          # remove stale pid file
    fi
  fi

  # start service in background and store process pid
  $service_cmd >/dev/null &
  echo $! > $service_pid
elif  [ $# -eq 1 -a "$1" = "stop" -a -f "$service_pid" ]; then
  kill -0 $(cat $service_pid) 2>/dev/null # check pid
  if [ $? -eq 0 ]; then
    kill $(cat $service_pid) # kill process if it is running
  fi
  unlink $service_pid
fi
