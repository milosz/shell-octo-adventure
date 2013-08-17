#!/bin/sh
# Convert Mbox to Maildir
# This script doesn't work recursively and doesn't expect any subdirectories 
# but that can be simply resolved by using find command.

# Mbox mailboxes
maildir="/var/spool/mail"

# Directory to save converted mailboxes
newdir="/root/mail_ready_to_move/"

# Path to Perfect_maildir script
tool="/root/bin/perfect_maildir.pl"

if [ -d ${newdir} ]; then
  rm -rf ${newdir}/
else
  mkdir -p ${newdir}
fi

for file in `ls ${maildir}/`; do
 mkdir -p ${newdir}/${file}/{cur,new}
 perl ${tool} ${newdir}/${file}< ${maildir}/${file}
done
