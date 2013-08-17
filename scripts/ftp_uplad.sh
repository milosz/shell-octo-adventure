#!/bin/sh
# Upload file to remote FTP server

# Server, username and password
server="my.ftp.server"
username="user1"
password="thisPasswordIsVisible"

# Local file location
local_dir="/home/user/log"
local_file="custom.log"

# Remote file location
remote_dir="logs"
remote_file="log_to_parse"

/usr/bin/ftp -n -i ${server} << EOF
user ${username} ${password}
cd ${remote_dir}
put ${local_dir}/${local_file} ${remote_file}
quit
EOF
