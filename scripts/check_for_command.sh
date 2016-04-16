#!/bin/sh
# Source: https://blog.sleeplessbeastie.eu/2016/06/26/how-to-check-for-command-inside-shell-script/

# check for specific command
# Return values:
#  0 - command is available
#  1 - command is not available
check_for_command(){
  command -v "$1" 1>/dev/null 2>&-
}

# example
commands="bash bashdb mc openssl-dev type"

for command in $commands; do
  if check_for_command "$command"; then
    printf "%-20s - %s\n" "$command" "command is available [$(type $command)]"
  else
    printf "%-20s - %s\n" "$command" "command is not not available"
  fi
done
