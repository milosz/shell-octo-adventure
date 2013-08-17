#!/bin/sh
# Check content encoding
# Example check_content_encoding.sh blog.sleeplessbeastie.eu

curl_command=`which curl`

if [ "$#" = "1" ]; then 
 $curl_command -s -I --compressed $1 | grep Content-Encoding
fi
