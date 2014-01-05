#!/bin/sh
# Print number of zombie processes

ps ax | awk '{if ($3=="Z") s++}; END {print s}'
