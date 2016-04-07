#!/bin/sh
# Inform every PostgreSQL cluster to reload its configuration
# Source: https://blog.sleeplessbeastie.eu/2016/03/14/how-to-reload-postgresql-cluster/

pg_lsclusters -h | \
  tr -s " " | \
  cut -d " " -f 1-2 | \
  parallel --colsep " " sudo pg_ctlcluster {1} {2} reload

