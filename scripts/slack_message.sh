#!/bin/bash
# send message to slack channel
#
# Description:
# https://blog.sleeplessbeastie.eu/2017/06/12/how-to-post-message-from-command-line-into-slack/

# define the boundaries after which the message will be sent will be sent as an attachment
# count "c" characters or "l" lines from stdin 
stdin_check="l"
# define number of characters or lines from stdin
stdin_count="2"

# define usage function
function usage {
  echo "Basic connection parameters:"
  echo " -h hook_url"
  echo " -c channel"
  echo " -u username"
  echo " -i icon"
  echo " -p enable|disable (markdown)"
  echo
  echo "Define message using file contents:"
  echo " -F \"file\""
  echo " -C color"
  echo " -T \"title\""
  echo
  echo "Define message using parameter:"
  echo " -m \"message\""
  echo
  echo "Otherwise, define message using standard input."
  echo
}

# curl is an essential application used to send message
if ! command -v curl &>/dev/null; then
  echo "Error: curl is missing"
  exit 1
fi

# display usage if no arguments are passed
if [ "$#" = "0" ];then
  usage;
  exit;
fi

# parse arguments
while getopts "h:c:u:m:i:C:F:T:p:" option; do
  case $option in
    "h")
      slack_hook_url=${OPTARG}
      ;;
    "c")
      slack_channel=${OPTARG}
      ;;
    "u")
      slack_username=${OPTARG}
      ;;
    "i")
      slack_icon=${OPTARG}
      ;;
    "C")
      slack_color=${OPTARG}
      ;;
    "F")
      slack_file=${OPTARG}
      ;;
    "T")
      slack_title=$(echo -e "${OPTARG}" | sed 's/\"/\\"/g' | sed "s/'/\'/g" | sed 's/`/\`/g')
      ;;
    "p")
      if [ "${OPTARG}" == "disable" ]; then
        slack_markdown="false"
      else
        slack_markdown="true"
      fi
      ;;
    "m")
      slack_message=${OPTARG}
      ;;
    \?|:)
      usage
      exit
      ;;
    esac
done

# verify basic parameters
if [ -z "$slack_hook_url" ] || [ -z "$slack_channel" ] || [ -z "$slack_username" ]; then
  echo "Error: Basic connection parameters are missing"
  exit 1
fi

# set default icon if not defined
if [ -z "$slack_icon" ]; then
  slack_icon="ghost"
fi

# read message 
if [ -n "$slack_file" ]; then
  if [ -f "$slack_file" ]; then
    # read message using file (-F)
    file=$(cat $slack_file)
  else
    echo "Error: File not found"
    exit 1
  fi
fi
if [ -n "$slack_message" ]; then
  # read message (-m) message parameter
  message="$slack_message"
else 
  if [ ! -t 0 ]; then 
    # read message from stdin
    message=$(cat /dev/stdin)
  fi
fi

# define header and color
if [ -n "$slack_title" ]; then
  title="\"title\":\"${slack_title}\" ,"
  if [ -z "$slack_file" ]; then
    file="$message"
    slack_file="/dev/null"
  fi
else
  title=""
fi

if [ -n "$slack_color" ]; then
  color="\"color\":\"${slack_color}\" ,"
  if [ -z "$slack_file" ]; then
    file="$message"
    slack_file="/dev/null"
  fi
else
  color=""
fi
# do not send empty message
if [ -z "${message}" ] && [ -z "${file}" ]; then
  echo "Error: There is nothing to send"
  exit 1
fi

# send message as attachment if it is bigger then defined values so it can be folded up
if [ -z "$slack_file" ]; then
  count=$(echo -e "${message}" | wc -${stdin_check})
  if [ "$count" -gt "$stdin_count" ]; then
    # activate small cheat
    file="$message"
    slack_file="/dev/null"
  fi
fi

# escape message and prepare text property
if [ -n "${message}" ]; then
  escaped_message=$(echo -e "${message}" | sed 's/\"/\\"/g' | sed "s/'/\'/g" | sed 's/`/\`/g')
  text="\"text\": \"${escaped_message}\""
fi

# escape file contents and prepare text property
if [ -n "${file}" ]; then
  escaped_file=$(echo -e "${file}" | sed 's/\"/\\"/g' | sed "s/'/\'/g" | sed 's/`/\`/g')
  file="\"text\": \"${escaped_file}\""
fi

# defince json
markdown="\"mrkdwn\": false,"
if [ -n "$slack_file" ]; then
  if [ "$slack_markdown" == "true" ]; then
    markdown="\"mrkdwn_in\": [\"text\"],"
    #markdown="\"mrkdwn\": true,"
  fi
  json="{\"channel\": \"${slack_channel}\", \"username\":\"${slack_username}\", \"icon_emoji\":\":${slack_icon}:\", \"attachments\":[{ ${color} ${title} ${markdown} ${file}}]}"
else
  if [ "$slack_markdown" == "true" ]; then
    markdown="\"mrkdwn\": true,"
  fi
  json="{\"channel\": \"${slack_channel}\", \"username\":\"${slack_username}\", \"icon_emoji\":\":${slack_icon}:\", ${markdown} ${text}}"
fi

# send message
curl -s -d "payload=$json" $slack_hook_url
