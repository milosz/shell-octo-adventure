#!/bin/bash
# Create cover images from e-books in sub-directories
# This shell script is not recursive
# https://blog.sleeplessbeastie.eu/2015/06/29/how-to-extract-cover-image-from-an-e-book/

# maximum width and height of the output image
maxsize="200x200"

for directory in */;do
  if [ -d "$directory" ]; then
    echo "Processing sub-directory: "${directory%%/}
    mkdir -p "${directory}covers"
    for ebook in "${directory}"*.pdf; do
      ebook="$(basename "$ebook")"
      if [ ! -f "${directory}covers/${ebook%%.pdf}.png" -a -f "${directory}${ebook}" ]; then
        echo "  Processing e-book: $ebook"
        convert "${directory}${ebook}"[0] -resize $maxsize "${directory}covers/${ebook%%.pdf}.png" 2>/dev/null
      fi
    done
  fi
done
