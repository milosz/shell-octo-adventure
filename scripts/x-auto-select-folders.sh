#!/bin/sh
# select all folders
# https://blog.sleeplessbeastie.eu/2013/01/21/how-to-automate-mouse-and-keyboard/

# used commands
xprop_command=`which xprop`
xdotool_command=`which xdotool`
xte_command=`which xte`
visgrep_command=`which visgrep`
xwd_command=`which xwd`
xwdtopnm_command=`which xwdtopnm`
pnmtopng_command=`which pnmtopng`
xwininfo_command=`which xwininfo`

# PAT file
pat_file="/home/milosz/Documents/folder.pat"

if [ -n "$xprop_command" -a -n "$xdotool_command" -a -n "$xte_command" -a -n "$xwd_command" -a -n "$xwininfo_command" ]; then
  # get active window id
  active_window_id=`$xdotool_command getactivewindow`

  # get class of the active window
  window_class=`$xprop_command -id $active_window_id | sed -n -e "s/^WM_CLASS(STRING).*\"\(.*\)\", \".*\"/\1/ p"`

  # execute only when active window is Google Chrome
  if [ "$window_class" = "konqueror" ]; then
    # create temporary file to store screen shot
    tmp_file=`mktemp`

    # move active window to foreground
    $xdotool_command windowactivate $active_window_id

		# create window screen shot
    $xwd_command -id $active_window_id | $xwdtopnm_command | $pnmtopng_command > $tmp_file

    # search for a pattern (remove ' 0' at the end of each line)
    rpos=`${visgrep_command} $tmp_file $pat_file $pat_file | sed s/\ 0//`

    # press shift and click on each folder
    for folder_pos in $rpos; do
       # get window position
       x1=`$xwininfo_command -id $active_window_id | awk '/Absolute upper-left X/ {print $NF}'`
       y1=`$xwininfo_command -id $active_window_id | awk '/Absolute upper-left Y/ {print $NF}'`

       # get found pattern position (inside window)
       x2=`echo $folder_pos | sed "s/\(.*\),.*/\1/"`
       y2=`echo $folder_pos | sed "s/.*,\(.*\)/\1/"`

       # calculate resulting position (add '5' to be inside)
       x=`expr $x1 + $x2 + 5`
       y=`expr $y1 + $y2 + 5`

       $xte_command "keydown Shift_L" "mousemove $x $y" "mouseclick 1" "keyup Shift_L"
    done

    # remove temporary file
    unlink $tmp_file
  fi
fi

