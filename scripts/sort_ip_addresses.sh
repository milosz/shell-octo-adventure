#!/bin/sh
# Check content encoding
# Sort ip addresses found in file used as first parameter

if [ "$#" = "1" ]; then 
 sort -t. +0n -1n +1n -2n +2n -3n +3n $1
fi
