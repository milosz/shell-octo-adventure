#!/bin/bash
# colorize text
# https://blog.sleeplessbeastie.eu/2014/02/17/how-to-colorize-text-in-terminal/

# define "arguments" associative array
declare -A arguments;

# define "position" parameter and set it to zero
declare -i postition;
position=0;

# define "colors" associative array
declare -A colors;
colors=([R]=31 [G]=32 [Y]=33 [B]=34 [M]=35 [C]=36 [r]=91 [g]=92 [y]=93 [b]=94 [m]=95  [c]=96)

# define function to add "color" and "regex" to the "arguments" array
function add_argument {
  arguments[$position.color]="$1";
  arguments[$position.regex]="$2";
  let position++;
}

# define usage function
function usage {
  echo "Sample usage:"
  echo "$ cat /etc/passwd | $0 -g \"\d\" -B \"bash\""
  echo -e "root:x:\e[92m0\e[0m:\e[92m0\e[0m:root:/root:/bin/\e[34mbash\e[0m";
  echo
  echo "Color parameters:";
  echo -e "-R \e[31mtext\e[0m -r \e[91mtext\e[0m";
  echo -e "-G \e[32mtext\e[0m -g \e[92mtext\e[0m";
  echo -e "-Y \e[33mtext\e[0m -y \e[93mtext\e[0m";
  echo -e "-B \e[34mtext\e[0m -b \e[94mtext\e[0m";
  echo -e "-M \e[35mtext\e[0m -m \e[95mtext\e[0m";
  echo -e "-C \e[36mtext\e[0m -c \e[96mtext\e[0m";
}

# special case if no arguments are passed
if [ "$#" = "0" ]; then
  usage;
  exit;
fi

# parse arguments
while getopts "R:G:Y:B:M:C:r:g:y:b:m:c:" option; do
    case $option in
	"R" | "G" | "Y" | "B" | "M" | "C" | "r" | "g" | "y" | "b" | "m" | "c")
	    add_argument "${option}" "${OPTARG}";
	    ;;
	\?|:)
	    usage
	    exit;
	    ;;
    esac
done

# parse input
while read line; do
  for i in $(seq 0 $((position-1))); do
    line=$(echo "$line" | ssed -R -e "s/(?<!\x1b\[|\x1b\[[0-9]|\x1b\[[0-9][0-9])(${arguments[$i.regex]})/\x1b\[${colors[${arguments[$i.color]}]}m\1\x1b\[0m/g")
  done

  echo -e $line;
done
