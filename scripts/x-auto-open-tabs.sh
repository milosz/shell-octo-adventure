#!/bin/sh
# open pre-defined tabs in Google Chrome
# https://blog.sleeplessbeastie.eu/2013/01/21/how-to-automate-mouse-and-keyboard/

# used commands
xprop_command=`which xprop`
xdotool_command=`which xdotool`
xte_command=`which xte`

if [ -n "$xprop_command" -a -n "$xdotool_command" -a -n "$xte_command" ]; then
  # get active window id
  active_window_id=`$xdotool_command getactivewindow`

  # get class of the active window
  window_class=`$xprop_command -id $active_window_id | sed -n -e "s/^WM_CLASS(STRING).*\"\(.*\)\", \".*\"/\1/ p"`

  # execute only when active window is Google Chrome
  if [ "$window_class" = "google-chrome" ]; then
    # open debian.org in new tab
    $xte_command "sleep 1" "keydown Control_L" "key t" "keyup Control_L"
    $xte_command "str debian.org" "key Return"

    # open lwn.net in new tab
    $xte_command "keydown Control_L" "key t" "keyup Control_L"
    $xte_command "str lwn.net" "key Return"

    # open debian-news.net in new tab
    $xte_command "keydown Control_L" "key t" "keyup Control_L"
    $xte_command "str debian-news.net" "key Return"

    # open freecode.com in new tab
    $xte_command "keydown Control_L" "key t" "keyup Control_L"
    $xte_command "str freecode.com" "key Return"

    # execute 'open previous tab' three times
    for i in $(seq 1 3); do
      $xte_command "keydown Control_L" "keydown Shift_L" "key Tab" "keyup Shift_L" "keyup Control_L"
    done
  fi
fi
