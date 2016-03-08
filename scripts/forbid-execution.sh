#!/bin/sh
# shell script to demonstrate simple protection system
# as it cannot be executed from different directory

if [ "$(pwd)" != "$(dirname $(readlink -f  $0))" ]; then
  echo "Do not run $(basename $0) script from outside of the $(dirname $(readlink -f  $0)) directory"
  exit
fi

echo "Test passed"
