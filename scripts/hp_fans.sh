#!/bin/bash
# Display fans running at least 20% of max
#
# Source: https://blog.sleeplessbeastie.eu/2017/02/20/how-to-use-hp-management-command-line-interface/
#
# #4   SYSTEM          Yes     NORMAL  21%     Yes        0        Yes
# #5   SYSTEM          Yes     NORMAL  35%     Yes        0        Yes
# #6   SYSTEM          Yes     NORMAL  35%     Yes        0        Yes
#

sudo hpasmcli -s "show fan" | awk '0+$5 >= 20 {print}'
