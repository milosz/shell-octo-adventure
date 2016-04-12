#!/bin/sh
# search through man pages
# Source: https://blog.sleeplessbeastie.eu/2016/06/06/how-to-search-through-manual-pages/
#
# Usage:
# man_search.sh manual_name search_pattern
#
# Examples:
# man_search.sh ^tar absolute
# man_search.sh fopen fopen\( 

# use colors: always, never
grep_colors="always"

# display surrounding lines
grep_lines="1"

if [ "$#" -eq 2 ]; then
  manual="$1"
  pattern="$2"

  manuals=$(man -k $1) # Important:
                       # Use "-k" parameter or "-f" if you want to be strict

  echo "$manuals" | while read manual_line; do
    manual_page=$(echo $manual_line | sed 's/\(.*\) (.*) [ ]*- .*/\1/')
    manual_section=$(echo $manual_line | sed 's/.* (\(.*\)) [ ]*- .*/\1/')

    matches=$(man $manual_section $manual_page 2>/dev/null | grep --color=$grep_colors -C $grep_lines -e "$pattern")

    if [ -n "$matches" ]; then
      echo "$matches" | while read match; do
        echo "$manual_page ($manual_section): $match"
      done
    fi
  done 
fi
