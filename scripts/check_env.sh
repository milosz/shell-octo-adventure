#!/bin/bash
# Print process environment
#
# Source: https://blog.sleeplessbeastie.eu/2017/01/16/how-to-display-process-environment/
#
# Examples:
#   $ sudo check_env.sh 16460
#   $ sudo check_env.sh tmux
#

# use only as root (sudo)
if [ "$(whoami)" != "root" ]; then
  echo "This shell script requires root privilege"
  exit 1
fi

# execute only if there is a param provided
if [ -n "$1" ]; then
  if [ "$1" -eq "$1" ] 2>/dev/null; then
    # param is a number - process id
    if [ -f "/proc/${1}/environ" ]; then
      echo "PID ${1}: $(cat /proc/${1}/cmdline)" 
      cat /proc/${1}/environ | tr '\0' '\n' | tr -s '\n'
    fi
  else
    # param is not a number - process name
    pgrep "$1" 2>/dev/null | xargs -r -I {} sh -c "echo \"-- PID: {}: \$(cat /proc/{}/cmdline)\"; cat /proc/{}/environ;" | tr '\0' '\n' | tr -s '\n'
    echo
  fi
fi
