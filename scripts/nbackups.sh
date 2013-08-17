#!/bin/sh
# Backup directory and keep last N backups

# Directory containing backups 
# It cannot contain any other data
backup_dir="/here/i/keep/backups"
# Directory to backup
backup_data="/important/data/to/backup"

# Date format - 22.06.2010_1700
date=`date +%d.%m.%Y_%H%M`
#  Backup name - important_data_22.06.2010_1700.tgz
tarball_name="important_data_"${date}".tgz"

# How many backups to keep?
backups=7

# Check if backup directory exist
if [ ! -d "${backup_dir}" ]; then
  echo "Backup directory does not exist"
  exit 1
fi

# Create backup and change ownership
tar cvfz ${backup_dir}/${tarball_name} $backup_data 1>/dev/null 2>&1
chown backup:backup ${backup_dir}/${tarball_name}

# Last part - remove old backups
# It could be more strict in next line
files=`ls -A -t ${backup_dir}`

i=1

for file in $files
do
  if [ "${i}" -le  "${backups}" ]; then
    echo "Keeping " $file;
  else
    echo "Removing " $file
    rm ${backup_dir}/${file}
  fi
   i=`expr $i + 1`
done
