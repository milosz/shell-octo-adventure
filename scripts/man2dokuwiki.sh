#!/bin/sh
# Convert manual pages to DokuWiki
# https://blog.sleeplessbeastie.eu/2015/04/13/how-to-convert-manual-pages-to-dokuwiki/
# dependencies: groff, roffit, pandoc (at least 1.13)

# language code
# EN (default): ""
# PL          : "pl"
langcode=""

# man paths
manpaths=$(manpath)

# output directory
outputdir="/home/milosz/en"

if [ ! -d "$outputdir" ]; then
  mkdir -p "${outputdir}"
  for n in $(seq 1 8); do
    mkdir "${outputdir}/man${n}"
  done
fi

# store old IFS value
OIFS=$IFS

IFS=":" # manpath uses ":" as separator
for manpath in $(manpath); do
  IFS=$OIFS # restore IFS inside this loop

  mandir="${manpath}/${langcode}"
  for section in $(find ${mandir} -type d -name man? -maxdepth 1 -exec basename \{\} \; 2>/dev/null); do
    # for each available manual page   
    for manpage in $(find ${mandir}/${section}/ -type f); do
       if [ -z "$langcode" ]; then # en
         zcat ${manpage} | groff -Thtml -P -l -mmandoc 2>/dev/null | pandoc -f html -t dokuwiki -o ${outputdir}/${section}/$(basename $manpage .gz).txt
       else                        # pl, fr, de,  ...
         zcat ${manpage} | roffit --bare 2>/dev/null | pandoc -f html -t dokuwiki -o ${outputdir}/${section}/$(basename $manpage .gz).txt 
       fi
    done
  done
done
