#!/bin/bash

dbcmd="mysql -h ${DB_HOST} -P ${DB_PORT} -u "${DB_USER}" "-p${DB_PASSWORD}""

echo "Waiting 120s for database to be ready..."
counter=1
while ! ${dbcmd} -e "show databases;" > /dev/null 2>&1; do
  sleep 1
  counter=$((counter + 1))
  if [ ${counter} -gt 120 ]; then
      >&2 echo "ERROR: Failed to connect to database on $DB_HOST"
      exit 1
  fi;
done
echo "Database ready!"

counttables=$(echo 'SHOW TABLES' | ${dbcmd} "$DB_NAME" | wc -l)

if [ "${counttables}" -eq "0" ]; then
  echo "Updating database schema..."
  php build-base.php

  echo "Creating admin user..."
  php adduser.php ${GUI_USERNAME} ${GUI_PASSWORD} 10 librenms@librenms.docker
fi