#!/bin/sh
# Browser sandbox
# Do not forget to edit sudoers file
# Description can be found at http://blog.sleeplessbeastie.eu/2013/07/19/how-to-create-browser-sandbox/

# display used to show browser
SANDBOX_DISPLAY=":33"

# sandbox user
SANDBOX_USER="browser_sandbox"

# authentication cookie
SANDBOX_MCOOKIE=`mcookie`

# authentication file
SANDBOX_XAUTH="/home/milosz/.Xauthority-sandbox"

# local X11 sockets, used to determine if application is running
LOCAL_SOCKETS="/tmp/.X11-unix"

# window width and height
WIDTH=1000
HEIGHT=700

# application to start
# width and height are raised above window dimensions to occupy full window
APPLICATION="iceweasel -width $(expr $WIDTH + 1) -height $(expr $HEIGHT + 1)"

# clear authentication files
clear_auth_files() {
  # clear authentication file
  if [ -e $SANDBOX_XAUTH ]; then
    unlink $SANDBOX_XAUTH
  fi

  # create empty file
  touch $SANDBOX_XAUTH

  # clear authentication file for SANDBOX_USER
  sudo su - $SANDBOX_USER << EOC
    if [ -e .Xauthority ]; then
      unlink .Xauthority 
    fi
    touch .Xauthority
EOC
}

if [ ! -e ${LOCAL_SOCKETS}/X${SANDBOX_DISPLAY#:} ]; then
  # display is not active

  # clear stalled authentication files
  clear_auth_files

  # store authentication cookie for chosen display
  xauth -f ${SANDBOX_XAUTH} add ${SANDBOX_DISPLAY} . ${SANDBOX_MCOOKIE}
  sudo su - $SANDBOX_USER << EOC
    xauth add ${SANDBOX_DISPLAY} . ${SANDBOX_MCOOKIE}
EOC

  # start Xephyr and application
  Xephyr -auth ${SANDBOX_XAUTH} -screen ${WIDTH}x${HEIGHT} -br -nolisten tcp $SANDBOX_DISPLAY &
  sudo su - $SANDBOX_USER << EOC
    DISPLAY=$SANDBOX_DISPLAY $APPLICATION
EOC

  # clear authentication files after session is closed
  # do not start application in the background to use this function
  clear_auth_files
else
  # display is active so application is already running
  # show simple error message
  if [ -n "$(which kdialog)" ]; then
    kdialog --error "Application is already running.<br/>Display ${SANDBOX_DISPLAY#:} is active."
  fi
fi
