#!/bin/sh
# Convert xml files to rrd

# Directory containing xml files
dir="/root/converted/xml"

# Sed regexp that will remove above directory
sed_regexp="s/\/root.*xml\///g"

# Directory that will contain rrd files 
newdir="/var/www/newcacti/rrd"

if [ -d ${newdir} ]; then
  rm -rf ${newdir}/
fi

directories=`find ${dir}/ -type d | sed ${sed_regexp}`
for wdir in $directories; do
  mkdir -p ${newdir}/$wdir
done

files=`find ${dir} -name *.xml | sed ${sed_regexp}`

for file in $files; do
  newfile=`echo ${file} | sed s/\.xml/\.rrd/`
  rrdtool restore ${dir}/${file} ${newdir}/${newfile}
done
