#!/bin/sh
# Script designed to backup configuration of SPS switches
#
# Example usage:
# $ sh sps_backup.sh 10.2.2.3 10.2.2.4
#
# More information: http://blog.sleeplessbeastie.eu/2011/01/20/scripting-sps-switches/

# Commands
expect=`which expect`
sed=`which sed`

# Archive name
ar_date=`date +"%d.%m.%y_%H%M%S"`
ar_name="sps_${ar_date}.tgz"

# SSH
ssh=`which ssh`
ssh_port="22"

# get_credentials - Get username and password
get_credentials(){
 echo -n "Username: "
 read user

 oldmodes=`stty -g`
 stty -echo
 echo -n "Password: "
 read pass
 stty $oldmodes
 echo

 export pass
 export user
}

# get_config - create expect script
get_config() {
cat << EOF
#!${expect} -f
log_user 0
exp_internal 0
sleep 3

spawn ${ssh} ${host} -p ${ssh_port}

expect {
  "The authenticity of host" {
    send "yes\r"
  }
}

expect  "User Name:" {
  send "$user"
  send "\r"
}
expect  "Password:" {
  send "$pass"
  send "\r"
}

expect {
  "User Name:" {
    exit 1
  }
  "SPS*#" {
    send "show startup-config\r"
    while (1) {
      expect {
        timeout break
        "" {
          puts "\$expect_out(buffer)"
          send " "
        }
        "SPS*#" {
          puts "\$expect_out(buffer)"
          break
        }
      }
    }
  }
}
send "exit\r"

exit 0
EOF
}

# Get login details
get_credentials

# Create temporary directory
temp_dir=`mktemp -d` || exit 1

for host in  ${*}; do
  temp_file="${temp_dir}/${host}"

  # Get config
  get_config ${host} | ${expect} -f - | while read line
  do
    echo $line >> $temp_file
  done

  # Remove unnecessary stuff
  if [ -f ${temp_file} ]; then
    sed -ci -e "/^User.*/d"             $temp_file
    sed -ci -e "/^Pass.*/d"             $temp_file
    sed -ci -e "/More.*return*/d"       $temp_file
    sed -ci -e "/show startup-config/d" $temp_file
    sed -ci -e "/^SPS.*#$/d"            $temp_file
    sed -ci -e "s/^M//g"                $temp_file
    sed -ci -e "/^ $/d"                 $temp_file
    sed -ci -e "s/^\ //g"               $temp_file
    sed -ci -e "/^$/d"                  $temp_file
  fi

  # Check if we got config
  # It will contain "password ..." line
  file_check=`cat ${temp_file} | grep "^password"}`
  if [ -n "${file_check}"]; then
    echo -e "${host}\tOK"
  else
    echo -e "${host}\tError"
    rm ${temp_file}
  fi
done

# Create archive
directory=`pwd`
cd ${temp_dir} && tar cfz ${directory}/${ar_name} .

# Clean up
rm    ${temp_dir}/*
rmdir ${temp_dir}

echo "Archive contents:"
tar tfz ${directory}/${ar_name}
