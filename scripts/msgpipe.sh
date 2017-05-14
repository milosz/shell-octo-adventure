#!/bin/bash
# Proof of concept shell script:
#   Display message provided from standard input or as an parameter
#
# Source:
#  https://blog.sleeplessbeastie.eu/2017/06/05/how-to-display-message-provided-from-standard-input-or-as-an-parameter/
#

# display usage information
function usage {
  echo "Print message provided from standard input or as an parameter"
  echo
  echo "Parameters:"
  echo " (none)       - set message from standard input"
  echo " -h           - help"
  echo " -m \"message\" - set message using parameter"
  echo " -t \"message\" - set message from standard input or using this parameter if the first one is empty"
  echo
  echo Examples:
  echo " \$ ${0} -m \"my message\""
  echo " \$ df -hs | ${0}"
  echo " \$ ls -lh /backup/ | ${0} -t \"There are no any backups\""
  exit
}

# display error message on standart erorr and return exit code 1
function error {
  if [ -n "$1" ]; then
    echo "$1" >&2
  fi
  exit 1
}

# read message from standard input
function read_stdin {
  if [ ! -t 0 ] && [ -p /dev/stdin ]; then
    message=$(cat /dev/stdin)
  fi
}

# read message from standard input if parameters are not provided
if [ "$#" = "0" ];then
  read_stdin
  if [ -z "$message" ]; then
    error "Error: Message is empty or not provided using standard input."
    exit
  fi
fi

# set helper variables
t_set=0;
m_set=0;

# parse arguments
while getopts ":m:t:h" option; do
  case $option in
    "m")
      if [ "$t_set" -eq "1" ]; then error "Error: Do not use both -m and -t parameters at the same time"; fi
      m_set=1
      message=${OPTARG}; 
      ;;
    "t")
      if [ "$m_set" -eq "1" ]; then error "Error: Do not use both -m and -t parameters at the same time"; fi
      t_set=1
      read_stdin
      if [ -z "$message" ]; then message=${OPTARG}; fi
      ;;
    "h")
      if [ "$#" -gt "1" ]; then error "Error: -h is a distinct parameter and cannot be combined with others"; fi
      usage
      ;;
    \?)
      error "Invalid option: -${option}"
      ;;
    :)
      error "Option -${option}requires an argument."
      ;;
    esac
done

# 
if [ -z "$message" ]; then
  echo "Error: Message is not provided using standard input or as parameter"
  exit 1
fi

echo "Message:"
echo "$message"
