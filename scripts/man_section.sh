#!/bin/bash
# Simple shell script to open manual page and jump to specific section heading
# Usage:   man_section.sh section_heading manual_page
# Example: man_section.sh ESCAPE\ CHARACTERS ssh

# escape spaces for section name: "single param" -> "single\ param"
section=`echo ${1} | $(which sed) -e 's/ /\\\ /g'`

if [ "$#" -eq "2" ]; then
  # use current locale
  $(which man) -P "less +/${section}" ${2} 2>/dev/null
  # use C locale
  # $(which man) --locale=C -P "less +/${section}" ${2} 2>/dev/null
else
  echo "Usage: ${0} section_heading manual_page"
fi

