#!/bin/sh
# Create web thumbnail for SemanticScuttle using cutycapt
# Description: http://blog.sleeplessbeastie.eu/2011/12/28/create-web-thumbnail-using-cutycapt/

if [ "$#" != "1" ]; then
  exit
fi

# Temporary image
temp_image="$(tempfile).png" 

# Output image
output_image=`echo $1 | sed s/^www\.//`

# First, second and third output_image's letters used for directory creation
first_letter=`echo ${output_image} | cut -c1`
second_letter=`echo ${output_image} | cut -c2`
third_letter=`echo ${output_image} | cut -c3`

# Output directory
output_directory="thumbnails/${first_letter}/${second_letter}/${third_letter}"

cutycapt --url=http://$1 --out=$temp_image
convert -resize 120 -crop 120x90+0+0 $temp_image $temp_image
mkdir -p $output_directory
cp ${temp_image} ${output_directory}/${output_image}.png
unlink $temp_image
