#!/bin/sh
# convert Gregorian calendar date to Julian Day Number 
# convert Julian Day Number to Gregorian calendar date 
#
# algorithm source:
# http://quasar.as.utexas.edu/BillInfo/JulianDatesG.html
# 
# examples:
# $ ./script.sh 15 5 2013
# 2456428
# $ ./script.sh 2456428
# 15/5/2013
#
# contact:
# milosz@sleeplessbeastie.eu
#


# gtojdn
# convert Gregorian calendar date to Julian Day Number
#
# parameters:
# day
# month
# year
# 
# example:
# gtojdn 15 5 2013
#
gtojdn() {
  if [ $2 -le 2 ]; then
    y=$(($3 - 1))
    m=$(($2 + 12))
  else
    y=$3
    m=$2
  fi
  d=$1

  x=$(echo "2 - $y / 100 + $y / 400" | bc)
  x=$(echo "($x + 365.25 * ($y + 4716))/1" | bc) 
  x=$(echo "($x + 30.6001 * ($m + 1))/1" | bc)
  
  echo $(echo "($x + $d - 1524.5)" | bc)
}


# jdntog
# convert Julian Day Number to Gregorian calendar
#
# parameters:
# jdn
#
# example:
# jdntog 2456428
#
# notes:
# algorithm is simplified
# loses accuracy for years less than in 1582
#
jdntog() {
  z=$(echo "($1+0.5)" | bc)
  w=$(echo "(($z - 1867216.25)/36524.25)/1" | bc)
  x=$(echo "$w / 4" | bc)
  a=$(echo "$z + 1 + $w - $x" | bc)
  b=$(echo "$a + 1524" | bc)
  c=$(echo "(($b - 122.1) / 365.25)/1" | bc)
  d=$(echo "(365.25 * $c)/1" | bc)
  e=$(echo "(($b - $d) / 30.6001)/1" | bc)
  f=$(echo "(30.6001 * $e)/1" | bc)

  md=$(echo "($b - $d - $f)/1" | bc)
  if [ $e -le 13 ]; then
    m=$(echo "$e - 1" | bc)
  else
    m=$(echo "$e - 13" | bc)
  fi

  if [ $m -le 2 ]; then
    y=$(echo "$c - 4715" | bc)
  else
    y=$(echo "$c - 4716" | bc)
  fi
 
  echo "$md/$m/$y"
  if [ "$y" -lt 1582 ]; then
    echo "not accurate as year < 1582"
  fi
}


#
# process the command-line arguments
#
if [ "$#" -eq 1 ]; then
  jdntog $1
elif [ "$#" -eq 3 ]; then
  gtojdn $1 $2 $3
else
  d=`date +%d`
  m=`date +%m`
  y=`date +%Y`
  gtojdn $d $m $y
fi
