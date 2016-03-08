!/bin/sh
# check major and minor PostgreSQL version for defined servers

# PostgreSQL servers
servers="localhost \
        192.168.1.145 \
        192.168.1.138 \
        192.168.0.130"

# current/previous major, minor version number
curr_major="9.1"
curr_minor="11"
prev_major="8.4"
prev_minor="21"

# PostgreSQL settings
PGUSER=pguser
PGPASSWORD=pgpass
PGDATABASE=postgres

# iterate over each server
for server in $servers; do
  export PGUSER PGPASSWORD PGDATABASE
  export PGHOST=$server

  version=$(psql -A -t -c "show server_version")
  major=$(echo $version | cut -d. -f1,2)
  minor=$(echo $version | cut -d. -f3)

  if [ "$major" = "$curr_major" ]; then
    if [ "$minor" -lt "$curr_minor" ]; then
      echo "$server:\tPlease update server to the latest version ($minor -> $curr_minor)";
    else
      echo "$server:\tAlready using current version ($version)"
    fi
  elif [ "$major" = "$prev_major" ]; then
    if [ "$minor" -lt "$prev_minor" ]; then
      echo "$server:\tPlease update server to the latest version ($major.$minor -> $major.$prev_minor)";
    else
      echo "$server:\tAlready using current version ($version)"
    fi
  else
    echo "$server:\tSkipped - Version mismatch ($major)"
  fi
done  
