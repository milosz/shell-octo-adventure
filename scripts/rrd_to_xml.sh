#!/bin/sh
# Convert rrd files to xml

# Directory containing .rrd files
dir="/var/www/cacti/rra"

# Sed regexp that will remove above directory
sed_regexp="s/\/var.*rra\///g"

# Directory that will contain xml files 
newdir="/root/rrdtool_converted/"

if [ -d ${newdir} ]; then
  rm -rf ${newdir}/
fi

directories=`find ${dir}/ -type d | sed ${sed_regexp}`
for wdir in ${directories}; do
  mkdir -p ${newdir}/${wdir}
done

files=`find ${dir} -name *.rrd | sed ${sed_regexp}`

for file in $files; do
  newfile=`echo ${file} | sed s/.rrd/.xml/`
  rrdtool dump ${dir}/${file} > ${newdir}/${newfile}
done
