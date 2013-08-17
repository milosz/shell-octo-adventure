#!/bin/sh
# Downscale video for portable device

OUTPUT_DIR="/home/milosz/converted"

mencoder ${1} -ovc xvid -xvidencopts bitrate=300 -vf scale=320:-3 -ofps 25 -oac lavc -lavcopts acodec=mp3:abitrate=64 -o ${OUTPUT_DIR}/${1##*/} 
