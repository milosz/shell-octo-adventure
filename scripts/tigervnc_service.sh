#!/bin/sh
# start/stop vnc service as regular user
# https://blog.sleeplessbeastie.eu/2014/11/11/how-to-monitor-tigervnc-service-using-monit/

# vnc server binary
vnc_bin="/opt/usr/bin/vncserver"

# vnc display
vnc_dsp="31"

# run vnc as user
vnc_usr="milosz"

# vnc pid file
vnc_pid="/var/run/tigervnc_${vnc_usr}_${vnc_dsp}.pid"

# get PID using internal vnc commands
vnc_getpid()
{
su $vnc_usr << EOF
$vnc_bin -list | sed -n -e "1,4d;s/:${vnc_dsp}[\t]\+\([0-9]\+\)/\1/p";
EOF
}

# start vnc service
vnc_start()
{
su $vnc_usr << EOF
$vnc_bin :${vnc_dsp} > /dev/null
EOF
}

# stop vnc service
vnc_stop()
{
su $vnc_usr << EOF
$vnc_bin -kill :${vnc_dsp} > /dev/null
EOF
}

if [ $# -eq 1 -a  "$1" = "start" ]; then
  if [ -n "$(vnc_getpid)" ]; then
    kill -0 $(vnc_getpid) 2>/dev/null
    if [ $? -eq 0 ]; then
      exit 2;
    else
      vnc_stop
    fi
  fi
  vnc_start
  vnc_getpid > $vnc_pid # update pid file for monit
elif [ $# -eq 1 -a "$1" = "stop" -a -n "$(vnc_getpid)" ]; then
  vnc_stop
  unlink $vnc_pid
fi
