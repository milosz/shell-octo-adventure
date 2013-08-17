#!/bin/bash
# Simple shell script to print section headings for specific manual page
# Usage:   man_sections.sh manual_page
# Example: man_sections.sh ssh

if [ "$#" -eq "1" ]; then
  # use current locale and keep empty lines
  $(which gzip) -c -d $(man -w ${1}) 2>/dev/null | $(which sed) -n -e "/^\.S[hH]/{s/\"//g;s/^.\{4\}//;p}"
  # use C locale and delete empty lines
  # $(which gzip) -c -d $(man --locale=C -w ${1}) 2>/dev/null | $(which sed) -n -e "/^\.S[hH]/{s/\"//g;s/^.\{4\}//;/^$/d;p}"
else
  echo "\$ ${0} manual_page"
fi

