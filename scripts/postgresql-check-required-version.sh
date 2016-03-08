#!/bin/sh
# check minimal/preferred PostgreSQL version for defined servers

# PostgreSQL servers
servers="localhost \
        192.168.1.145 \
        192.168.1.138 \
        192.168.0.130"

# minimal and preferred version number
minimal_version="80420"
preffered_version="90112"

# PostgreSQL settings
PGUSER=pguser
PGPASSWORD=pgpass
PGDATABASE=postgres

# iterate over each server
for server in $servers; do
  export PGUSER PGPASSWORD PGDATABASE
  export PGHOST=$server

  version=$(psql -A -t -c "show server_version_num")

  if [ "$version" -ge  "$preffered_version" ]; then
    echo "$server:\tRequirements fully met ($version)"
  else
    if [ "$version" -ge "$minimal_version" ]; then
      echo "$server:\tMinimal requirements met ($version)"
    else
      echo "$server:\tRequirements are not met ($version)"
    fi
  fi
done
