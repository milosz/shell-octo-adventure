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
     most_recent_version=$(printf "${required_version}\n${local_version}\n" | sort -h | tail -1)
     if [ "$local_version" == "$most_recent_version" ]; then
         echo "Package \"$required_package\" is installed, version constraint is met (\"$local_version\" is newer than \"$required_version\")"
         exit 0
     else
         echo "Package \"$required_package\" is installed, version constraint is not met (\"$local_version\" is older than \"$required_version\")"
         exit 1
     fi
     ;;
esac
