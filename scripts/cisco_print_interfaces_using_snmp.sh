#!/bin/sh
# simple shell script to demonstrate how to read interface statistics
# on Cisco Catalyst switch using SNMP protocol

# SNMP protocol version
snmp_proto="2c"

# SNMP community string
snmp_community="mycommunitystr"

# Cisco Catalyst switch IP address
snmp_addr="192.168.10.11"

# SNMP interface entry OID
snmp_oid="1.3.6.1.2.1.2.2.1"

# temporary filename
snmp_file=$(mktemp)

# read and store interface entries, exit on error
snmpwalk -On -v $snmp_proto -c $snmp_community $snmp_addr $snmp_oid > $snmp_file 2>/dev/null
if [ "$?" -ne "0" ]; then
  exit 1
fi

# get interface indexes
indexes=$(sed -n -e "s/.1.3.6.1.2.1.2.2.1.1.\([0-9]\+\).*/\1/p" $snmp_file)

# get and print statistics for each interface using collected indexes
for index in $indexes; do
  ifDescr=$(sed -n -e "s/.1.3.6.1.2.1.2.2.1.2.${index} = .*: \(.*\)/\1/p" $snmp_file | tr -d \")
  ifType=$(sed -n -e "s/.1.3.6.1.2.1.2.2.1.3.${index} = .*: \(.*\)/\1/p" $snmp_file)
  ifMTU=$(sed -n -e "s/.1.3.6.1.2.1.2.2.1.4.${index} = .*: \(.*\)/\1/p" $snmp_file)
  ifSpeed=$(sed -n -e "s/.1.3.6.1.2.1.2.2.1.5.${index} = .*: \(.*\)/\1/p" $snmp_file)
  ifPhysAddress=$(sed -n -e "s/.1.3.6.1.2.1.2.2.1.6.${index} = .*: \(.*\)/\1/p" $snmp_file | xargs | tr " " ":")
  ifAdminStatus=$(sed -n -e "s/.1.3.6.1.2.1.2.2.1.7.${index} = .*: \(.*\)/\1/p" $snmp_file)
  ifOperStatus=$(sed -n -e "s/.1.3.6.1.2.1.2.2.1.8.${index} = .*: \(.*\)/\1/p" $snmp_file)
  ifLastChange=$(sed -n -e "s/.1.3.6.1.2.1.2.2.1.9.${index} = .*: \(.*\)/\1/p" $snmp_file)
  inOct=$(sed -n -e "s/.1.3.6.1.2.1.2.2.1.10.${index} = .*: \(.*\)/\1/p" $snmp_file)
  inUcastPkts=$(sed -n -e "s/.1.3.6.1.2.1.2.2.1.11.${index} = .*: \(.*\)/\1/p" $snmp_file)
  inDiscards=$(sed -n -e "s/.1.3.6.1.2.1.2.2.1.13.${index} = .*: \(.*\)/\1/p" $snmp_file)
  inErrors=$(sed -n -e "s/.1.3.6.1.2.1.2.2.1.14.${index} = .*: \(.*\)/\1/p" $snmp_file)
  inUnkProt=$(sed -n -e "s/.1.3.6.1.2.1.2.2.1.15.${index} = .*: \(.*\)/\1/p" $snmp_file)
  outOct=$(sed -n -e "s/.1.3.6.1.2.1.2.2.1.16.${index} = .*: \(.*\)/\1/p" $snmp_file)
  outUcastPkts=$(sed -n -e "s/.1.3.6.1.2.1.2.2.1.17.${index} = .*: \(.*\)/\1/p" $snmp_file)
  outDiscards=$(sed -n -e "s/.1.3.6.1.2.1.2.2.1.19.${index} = .*: \(.*\)/\1/p" $snmp_file)
  outErrors=$(sed -n -e "s/.1.3.6.1.2.1.2.2.1.20.${index} = .*: \(.*\)/\1/p" $snmp_file)

  if [ -n "$ifMTU" ] && [ -n "$ifPhysAddress" ]; then
    printf "ifDescr: %s\tifType: %s\nifMTU: %s\tifSpeed: %s\nifPhysAddress: %s\nifAdminStatus: %s\tifOperStatus: %s\nifLastChange: %s\n" "$ifDescr" "$ifType" "$ifMTU" "$ifSpeed" "$ifPhysAddress" "$ifAdminStatus" "$ifOperStatus" "$ifLastChange"
    printf "inOct:  %12s\tinUcastPkts:  %12s\tinDiscards:  %12s\tinErrors:  %12s\n" "$inOct"  "$inUcastPkts"  "$inDiscards"  "$inErrors"
    printf "outOct: %12s\toutUcastPkts: %12s\toutDiscards: %12s\toutErrors: %12s\n" "$outOct" "$outUcastPkts" "$outDiscards" "$outErrors"
    printf "inUnkProt:  %s\n" "$inUnkProt"
  else
    printf "ifDescr: %s\tifType: %s\nifAdminStatus: %s\tifOperStatus: %s\n" "$ifDescr" "$ifType" "$ifAdminStatus" "$ifOperStatus"
  fi
  echo
done

# remove temporary file
unlink $snmp_file
