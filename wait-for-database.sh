#!/bin/sh
# wait-for-postgres.sh
# From the Docker product manual: https://docs.docker.com/compose/startup-order/

bundle install

set -e

host="$1"
port="$2"
shift
shift
pg_connect_cmd="nc -vz $host $port"
cmd="$@"

echo "!!!!!!!! --- !!!!!!!!"
echo "$pg_connect_cmd"

# Uncomment to stall this to run web server by docker exec
#while true; do
#sleep 2
#done

until $(exec $pg_connect_cmd); do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 5
done

>&2 echo "Postgres is up - executing command"
exec $cmd