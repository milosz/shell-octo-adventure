#!/bin/sh
# Simple "copy [directories] and verify [files]" shell script
# Sample usage: copy.sh /from_directory /to_directory
# https://blog.sleeplessbeastie.eu/2014/11/21/how-to-verify-copy-process/

# used commands
find_command=$(which find)
shasum_command=$(which sha256sum)
cat_command=$(which cat)
unlink_command=$(which unlink)

# copy command with additional arguments
copy_command=$(which cp)
copy_arguments="-rp" # recursive mode
                     # preserve mode, ownership, timestamps

# mail command and with used email address
mail_command=$(which mail)
mail_subject_argument="-s"
mail_address="milosz"

if [ -d "$1" -a ! -d "$2" ]; then
  # first  directory          exists
  # second directory does not exists

  # compute 256-bit checksums
  shasum_log=$(mktemp)
  (cd $1 && $find_command . -type f -exec $shasum_command '{}' \; > $shasum_log)

  # copy data
  copy_log=$(mktemp)
  $copy_command $copy_arguments "$1" "$2" > $copy_log

  # verify computed checksums
  verify_log=$(mktemp)
  (cd $2 && $cat_command $shasum_log | $shasum_command -c > $verify_log)
  shasum_exit_code="$?"

  # prepare message and send mail message
  mail_file=$(mktemp)
  if [ "$shasum_exit_code" -eq "0" ]; then
    mail_subject="Subject: ${0}: Success"
  else
    mail_subject="Subject: ${0}: Error"
  fi
  echo                                     >  $mail_file
  echo "Command-line: ${0} ${1} ${2}"      >> $mail_file

  if [ -s "$copy_log" ]; then
    echo                                   >> $mail_file
    echo "Copy process"                    >> $mail_file
    $cat_command $copy_log                 >> $mail_file
  fi

  if [ "$shasum_exit_code" -ne "0" ]; then
    echo                                   >> $mail_file
    echo "Verify process"                  >> $mail_file
    $cat_command $verify_log | grep -v OK$ >> $mail_file
  fi

  $mail_command $mail_subject_argument "${mail_subject}" $mail_address < $mail_file

  # cleanup temporary files
  $unlink_command $mail_file
  $unlink_command $verify_log
  $unlink_command $copy_log
  $unlink_command $shasum_log
else
  echo "Problem with parameters\nCommand-line: ${0} ${1} ${2}" | $mail_command $mail_subject_argument "${0}" $mail_address
  exit 5
fi
