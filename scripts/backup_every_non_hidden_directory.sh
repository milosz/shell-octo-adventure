#!/bin/bash
# Archive every non-hidden directory in current location
# Optionally it will also archive every file inside current location (it ignore dot files)
#
# $ cd /x/y/z
# $ archive.sh

# output directory
# - the same directory if empty
# - remember to use trailing slash, for example "/tmp/"
output_path="/tmp/"

# ****** optional
# first step - take care of files in current directory
archive_file="${output_path}$(pwd | awk -F/ '{print $NF}')_files.tgz"
find . -maxdepth 1 -type f -not -name ".*"  -exec tar czf "${archive_file}" {} +

# ****** main
# second step - take care of directories
for dir in */; do
  # remove trailing slash
  dir=`echo $dir | tr -d '/'`
  tar czf "${output_path}${dir}.tgz" "$dir"
done
