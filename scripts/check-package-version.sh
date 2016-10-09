#!/bin/sh
# perform different actions depending on package status

# required package version
required_package="apache2-utils"
required_version="2.4.10-10+deb8u7"

# local package version
local_version=$(/usr/bin/dpkg-query -W -f="\${Version}\n" $required_package 2>/dev/null)

# verify package version
case $local_version in
  "")
     echo "Package \"$required_package\" is not installed"
     ;;
  $required_version)
     echo "Package \"$required_package\" is installed, version constraint is met (\"$required_version\")"
     ;;
  *)
     echo "Package \"$required_package\" is installed, version constraint is not met (\"$local_version\" != \"$required_version\")"
     ;;
esac
