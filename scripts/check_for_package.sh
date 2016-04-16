#!/bin/sh
# Source: https://blog.sleeplessbeastie.eu/2016/06/23/how-to-check-for-package-inside-shell-script/

# check for specific package
# Return values:
#  0 - package is installed
#  1 - package is not installed, it is available in package repository
#  2 - package is not installed, it is not available in package repository
check_for_package(){
  if dpkg-query -s "${1}" 1>/dev/null 2>&1; then
    return 0   # package is installed
  else
    if apt-cache show "$1" 1>/dev/null 2>&1; then
      return 1 # package is not installed, it is available in package repository 
    else
      return 2 # package is not installed, it is not available in package repository
    fi
  fi
}

# example
packages="bash bashdb mc openssl-dev type"

for package in $packages; do
  if check_for_package "$package"; then
    printf "%-20s - %s\n" "$package" "package is installed"
  else
    if test "$?" -eq 1; then
      printf "%-20s - %s\n" "$package" "package is not installed, it is available in package repository"
    else
      printf "%-20s - %s\n" "$package" "package is not installed, it is not available in package repository"
    fi
  fi
done
