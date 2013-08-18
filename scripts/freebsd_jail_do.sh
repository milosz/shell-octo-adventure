#!/bin/sh
# execute set of commands inside each active jail
# This script is obsolete
# Source: http://blog.sleeplessbeastie.eu/2011/03/16/how-to-do-some-work-in-each-active-jail/

jails=`ezjail-admin list | grep -v "^STA" | grep -v "N/A" | grep -v "^\-" | awk '{ print $4}'`
for jail in $jails; do
   ezjail-admin console $jail  << COMMANDS
   # do something inside jail
   cd /var/mail/ && ls
COMMANDS
done

