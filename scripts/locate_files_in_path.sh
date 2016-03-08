#!/bin/sh
# print every script in PATH
# source: https://blog.sleeplessbeastie.eu/2015/01/13/how-to-locate-scripts-in-the-path/

IFS=:
for directory in $PATH; do
  for filename in $directory/*; do
    # print more information
    # sample output: /usr/bin/discover-config: POSIX shell script, ASCII text executable, with very long lines
    # filetype=$(file -L $filename | sed  -ne "/.*:.*script.*/p");

    # print less information
    # sample output: /usr/bin/discover-config: POSIX shell script
    filetype=$(file -L $filename | sed  -ne "s/\(.*: .* script\).*/\1/p")

    if [ -n "$filetype" ]; then
      echo "$filetype"
    fi
  done
done
