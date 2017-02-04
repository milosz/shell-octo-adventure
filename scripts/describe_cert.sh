#!/bin/bash
# Print certificate issuer and dates for provided address
#
# Source: https://blog.sleeplessbeastie.eu/2017/03/20/how-to-display-certificate-issuer-and-dates/
#
# Example:
#   $ describe_cert.sh sleeplessbeastie.eu
#   Connection to sleeplessbeastie.eu returned certificate for sleeplessbeastie.eu issued by Let's Encrypt valid from Jan 13 22:30:00 2017 GMT to Apr 13 22:30:00 2017 GMT
#
#   $ describe_cert.sh lwn.net
#   Connection to lwn.net returned certificate for *.lwn.net (*.lwn.net, lwn.net) issued by GeoTrust Inc. valid from Oct 12 18:06:09 2015 GMT to Oct 14 20:24:37 2018 GMT
#

# Enable/Disable colors
export TERM="xterm"
# export TERM="dumb"

# define colors
color_field=$(tput setaf 6)
color_default=$(tput sgr0)

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
    if [ "$certificate_size" -gt "54" ]; then
      certificate_issuer=$(openssl x509 -in $certificate_file -issuer -noout | awk -v FS="/" '{for (i=1;i<=NF;i++) {split($i,var,"="); if(var[1] == "O") print var[2]}}')
      certificate_cn=$(openssl x509 -in $certificate_file -subject -noout | awk -v FS="/" '{for (i=1;i<=NF;i++) {split($i,var,"="); if(var[1] == "CN") print var[2]}}')
      certificate_san=$(openssl x509 -in $certificate_file -text -noout -certopt no_subject,no_header,no_version,no_serial,no_signame,no_validity,no_subject,no_issuer,no_pubkey,no_sigdump,no_aux | sed -n -e "/X509v3 Subject Alternative Name/ {n;s/DNS://g;p}" | tr -s ' ' | sed -e "s/^ //")
      certificate_date_start=$(openssl x509 -in $certificate_file -startdate -noout | sed "s/.*=\(.*\)/\1/")
      certificate_date_end=$(openssl x509 -in $certificate_file -enddate -noout | sed "s/.*=\(.*\)/\1/")

      if [ -z "$ertificate_san" ] && [ "$certificate_san" != "$certificate_cn" ]; then
        certificate_alt=" (${color_field}${certificate_san}${color_default})"
      else
        certificate_alt=""
      fi
      echo "Connection to ${color_field}${website}${color_default} returned certificate for ${color_field}${certificate_cn}${color_default}${certificate_alt} issued by ${color_field}${certificate_issuer}${color_default} valid from ${color_field}${certificate_date_start}${color_default} to ${color_field}${certificate_date_end}${color_default}"
    fi
  fi
fi
