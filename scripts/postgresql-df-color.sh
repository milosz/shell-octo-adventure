#!/bin/sh
# iterate through postgres databases and pretty print its sizes

# define colors
color_tablespace=$(tput setaf 1)
color_database=$(tput setaf 5)
color_schema=$(tput setaf 4)
color_table=$(tput setaf 6)
color_default=$(tput sgr0)

# ensure that script is executed as postgres user
if [ "$(whoami)" != "postgres" ]; then
  echo "Execute as postgres user"
  exit
fi

# for each tablespace
for tablespace in $(psql -A -t -c "select spcname from pg_tablespace"); do
  tablespace_size=$(psql -A -t -c "select pg_size_pretty(pg_tablespace_size('${tablespace}'))")
  printf "%15s  ${color_tablespace}%s${color_default}\n" "${tablespace_size}" "$tablespace"

  # for each database
  for database in $(psql -A -t -c "select datname from pg_database join pg_tablespace on pg_database.dattablespace=pg_tablespace.oid where datistemplate is false and spcname like '${tablespace}'"); do
    database_size=$(psql -A -t -c "select pg_size_pretty(pg_database_size('${database}'))")
    printf "%15s    ${color_database}%s${color_default}\n" "$database_size" "$database"

    # for each schema
    for schema in $(psql -A -t -c "SELECT nspname FROM pg_namespace WHERE nspname not like 'pg_%' AND nspname not like  'information_schema'" -d ${database}); do
      schema_size=$(psql -A -t -c "select pg_size_pretty(sum(pg_total_relation_size(pg_class.oid))) from pg_class join pg_namespace on pg_class.relnamespace=pg_namespace.oid where nspname like '$schema'" -d ${database})
      if [ -z "$schema_size" ]; then
        schema_size="0 bytes"
      fi
      printf "%15s      ${color_schema}%s${color_default}\n" "$schema_size" "$schema"

      # for each table
      for table in $(psql -A -t -c "SELECT tablename FROM pg_tables where schemaname='${schema}'" -d ${database}); do
        table_size=$(psql -A -t -c "select pg_size_pretty(pg_total_relation_size(pg_class.oid)) from pg_class join pg_namespace on pg_class.relnamespace=pg_namespace.oid where nspname like '$schema' and relname like '$table'"  -d ${database})
        printf "%15s        ${color_table}%s${color_default}\n" "$table_size" "$table"
      done
    done
  done
done
tablespaces_size=$(psql -A -t -c "select pg_size_pretty(sum(pg_tablespace_size(spcname))) from pg_tablespace")
printf "%15s\n" "$tablespaces_size"
