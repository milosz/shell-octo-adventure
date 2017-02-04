#!/bin/bash
# Display temperature sensors readings ranging from at least 50'C
#
# Source: https://blog.sleeplessbeastie.eu/2017/02/20/how-to-use-hp-management-command-line-interface/
#
# #13       SYSTEM_BD            50C/122F   105C/221F
# #18       SYSTEM_BD            50C/122F   115C/239F
# #25       SYSTEM_BD            75C/167F   100C/212F
#

sudo hpasmcli -s "show temp" | awk '0+$3 >= 50 {print}'

