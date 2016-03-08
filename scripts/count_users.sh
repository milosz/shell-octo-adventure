#!bin/sh
# Count and print local user accounts

# configuration file and min/max uid values
SHADOW_CONFIG="/etc/login.defs"
UID_MIN=$(awk '$1 == "UID_MIN" {print $2}' $SHADOW_CONFIG)
UID_MAX=$(awk '$1 == "UID_MAX" {print $2}' $SHADOW_CONFIG)

# "nobody" user to be ignored
NOBODY_USR="nobody"
NOBODY_UID=65534

# password file
PASSWD_FILE="/etc/passwd"

awk -F: '($3 >= '$UID_MIN' && $3 <= '$UID_MAX') && \
          !($1 == '$NOBODY_USR' && $3 == '$NOBODY_UID') \
        { print $3 "\t" $1; SUM+=1 } \
        BEGIN { print "UID\tUsername"; SUM=0 } \
        END { print "Total: " SUM }' \
        $PASSWD_FILE
