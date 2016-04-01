#!/bin/bash
# fix bluetooth sound synchronization
# Source: https://blog.sleeplessbeastie.eu/2016/05/09/how-to-fix-bluetooth-sound-synchronization/
# References: http://askubuntu.com/questions/145935/get-rid-of-0-5s-latency-when-playing-audio-over-bluetooth-with-a2d

LANG=C

for card in $(pactl list cards short | awk '$2 ~ /^bluez_card/ { print $1 }'); do
  # Print device name
  echo -n "Found device: "
  pactl list cards  | awk -v card="#${card}" -v ORS="\n" -v FS="\n" -v RS=""  'split($1,var," ")  var[1] ~ /Card/ && var[2] == card { print }' | awk -v FS=" = " '/device.description/ { print $2}' | tr -d \"

  # Print profiles 
  pactl list cards | awk -v card="#${card}" -v ORS="\n" -v FS="\n" -v RS="" -e 'split($1,var," ")  var[1] ~ /Card/ && var[2] == card { print }'  | awk '/Profiles/,/Active/ {gsub(/^\t/,"",$0); print}'

  echo "Set profile: Headset Head Unit (HSP/HFP)" 
  pactl set-card-profile ${card} headset_head_unit

  echo "Set profile: Advanced Audio Distribution Profile (A2DP)"
  pactl set-card-profile ${card} a2dp_sink
done
