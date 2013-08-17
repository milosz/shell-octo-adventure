#!/bin/sh
# Display date of Easter

echo "Date of Easter"
echo -n "Current year: "
ncal -e $(date +"%Y")
echo -n "Next year: "
ncal -e $(date --date "next year" +"%Y")
