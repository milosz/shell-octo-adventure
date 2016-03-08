#!/bin/sh
# highlight text
# https://blog.sleeplessbeastie.eu/2014/02/10/how-to-highlight-text-in-terminal/
#
# Example usage:
# cat gpl-3.0.txt | head | highlight-text.sh "[A-Z]{2,}"

if [ ! -z "$1" ]; then
  while read line; do
    if [ -n "$(which ssed)" ]; then
      echo $(echo "$line" | ssed -R -e "s/(?<!\x1b\[|\x1b\[[01])($1)/\x1b\[1m\1\x1b\[0m/g");
    else
      echo $(echo "$line" | sed -e "s/\x1b\[1m/\x11/g" -e "s/\x1b\[0m/\x12/g" -e "s/\($1\)/\x1b\[1m\1\x1b\[0m/g" -e "s/\x11/\x1b\[1m/g"  -e "s/\x12/\x1b\[0m/g");
    fi
  done
else
  while read line; do echo $line; done
fi
