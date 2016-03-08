#!/bin/sh
# check if process exists and kill it

pid_file=/var/run/process.pid

kill -0 $(cat $pid_file) 2>/dev/null

if [ $? -eq 0 ]; then
  kill $(cat $pid_file)
fi
