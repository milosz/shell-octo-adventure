#!/bin/sh
# display PostgreSQL version for selected servers

# PostgreSQL servers
servers="localhost    \
         192.168.1.145 \
         192.168.1.138 \
         192.168.0.130"

# PostgreSQL settings
PGUSER=pguser
PGPASSWORD=pgpass
PGDATABASE=postgres

# print version for each server
for server in $servers; do
  export PGUSER PGPASSWORD PGDATABASE
  export PGHOST=$server
  echo -n "$server:\t"
  psql -A -t -c "select version()"
done
