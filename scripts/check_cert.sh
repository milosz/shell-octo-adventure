#!/bin/bash
# Print the number of days till certificate expiration
#
# Source: https://blog.sleeplessbeastie.eu/2017/04/03/how-to-display-days-till-certificate-expiration/
#
# Example:
#   $ check_cert.sh sleeplessbeastie.eu
#   81
#   $ check_cert.sh lwn.net
#   630
#
# Exit codes:
#   0   - certificate is not expired
#   1   - certificate is     expired
#   254 - certificate is empty
#   255 - DNS resolution failed
#

# temporary file to store certificate
certificate_file=$(mktemp)

# delete temporary file on exit
trap "unlink $certificate_file" EXIT

if [ "$#" -eq "1" ]; then
  website="$1"
  host "$website" >&-
  if [ "$?" -eq "0" ]; then
    echo -n | openssl s_client -servername "$website" -connect "$website":443 2>/dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > $certificate_file
    certificate_size=$(stat -c "%s" $certificate_file)
    if [ "$certificate_size" -gt "1" ]; then
      date=$(openssl x509 -in $certificate_file -enddate -noout | sed "s/.*=\(.*\)/\1/")
      date_s=$(date -d "${date}" +%s)
      now_s=$(date -d now +%s)
      date_diff=$(( (date_s - now_s) / 86400 ))
      echo "$date_diff"
      if [ "$date_s" -gt "$now_s" ]; then
        exit 0 # ok
      else
        exit 1 # not ok
      fi
    else
      exit 254
    fi
  else
    exit 255
  fi
fi
