#!/bin/bash
# Display temperature sensors readings exceeding threshold level
#
# Source: https://blog.sleeplessbeastie.eu/2017/02/20/how-to-use-hp-management-command-line-interface/
#
# #40       I/O_ZONE             77C/170F   75C/167F
#

sudo hpasmcli -s "show temp" | awk '$3~/^[0-9]/ && $4~/^[0-9]/ && 0+$3 > 0+$4 {print}'
