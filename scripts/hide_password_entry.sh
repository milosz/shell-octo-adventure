#!/bin/sh
# Hide password entry

get_user_and_pass(){
 echo -n "Username: "
 read username

 oldmodes=`stty -g`
 stty -echo
 echo -n "Password: "
 read password
 stty $oldmodes
 echo
}

get_user_and_pass

# See yourself
echo ${username}:${password}
