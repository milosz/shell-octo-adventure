#!/bin/bash
# create DokuWiki content
# create list of PDF files in current directory
# https://blog.sleeplessbeastie.eu/2015/06/29/how-to-extract-cover-image-from-an-e-book/

dir=$(basename $(pwd))

for pdf in *.pdf; do
cat << EOF
{{:bookshelf:$dir:covers:${pdf%%.pdf}.png?nolink |}}
**$(echo $pdf | sed s/.pdf// | sed "s/_/ /g"| sed "s/-/ /g")**\\\\
//$(pdfinfo $pdf | sed -ne "/Author:/ {s/^Author:\ *//;p}")//

{{:bookshelf:$dir:${pdf}|Download e-book}}
----

EOF
done

