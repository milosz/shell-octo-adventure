#!/bin/sh
# create image based jail in FreeBSD 7
# This script is obsolete
# Source: http://blog.sleeplessbeastie.eu/2011/03/16/how-to-do-some-work-in-each-active-jail/

ezjail="/usr/local/bin/ezjail-admin"
tail="/usr/bin/tail"

temp_file=`mktemp -q /tmp/jcreate.XXXXXX`

usage() {
  echo "Usage:"
  echo "jcreate.sh name ip size"
}

if [ "${#}" != "3" ]; then
  usage
else
  name=$1
  ip=$2
  size=$3
  ${ezjail} create -i -s ${size} -f default ${name} ${ip} > ${temp_file} 2>&1
  if [ "${?}" -eq "0" ]; then
    echo "Jail ${name} with address ${ip} and size ${size} created."
    echo "Log filename: ${temp_file}"
  else
    echo "There was an error"
    echo "Log filename: ${temp_file}"
    tail ${temp_file}
  fi
fi

