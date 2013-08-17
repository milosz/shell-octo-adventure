#!/bin/sh
# Simple script designed to automatically add hosts to ~/.ssh/known_host file
#
# Example usage:
# $ sh meet_hosts.sh 10.2.2.3 10.2.2.4
# 10.2.2.3      - Entry added successfully
# 10.2.2.4      - Entry added earlier
#
# $ cat /file/ip_addresses
# 10.2.2.3
# 10.2.2.4
#
# $ cat /path/ip_addresses | xargs sh meet_hosts.sh
# 10.2.2.3      - Entry added earlier
# 10.2.2.4      - Entry added earlier
#

# variables
expect=`which expect`
ssh="/home/milosz/openssh-5.2p1/ssh"
ssh_port="50022"
grep=`which grep`


# Functions

# meet_host - create expect script
# Return values:
# 0 - expect received "Are you sure you want to continue connecting (yes/no)"
#     and sent "yes" response
# 1 - expect didn't sent any response
# 2 - expect received "REMOTE HOST IDENTIFICATION HAS CHANGED!"
meet_host() {
cat << EOF
#!${expect} -f
log_user 0
exp_internal 0
set timeout 3

spawn ${ssh} ${host} -p ${ssh_port}
expect "WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!" {
  exit 2
}

expect "Are you sure you want to continue connecting (yes/no)?" {
  send "yes\r"
  sleep 2
  exit 0
}

exit 1
expect eof
EOF
}

# check_it - check expect exit code and print message
check_it() {
  check=`${grep} ${2} ~/.ssh/known_hosts`
  if [ "${check}" == "" ]; then
    printf "%-15s - %s\n" ${2} "Error adding entry"
  else
    case "$1" in
      "0")
        printf "%-15s - %s\n" ${2} "Entry added successfully"
        ;;
      "1")
        printf "%-15s - %s\n" ${2} "Entry was added earlier"
        ;;
      "2")
        printf "%-15s - %s\n" ${2} "Host verification failed"
        ;;
    esac
  fi
}


# Main
for host in  ${*}; do
  meet_host ${host} | ${expect} -f - 2> /dev/null
  check_it "${?}" "${host}"
done

