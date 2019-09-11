#!/bin/bash

dbcmd="mysql -h ${DB_HOST} -P ${DB_PORT} -u "${DB_USERNAME}" "-p${DB_PASSWORD}""

echo "Waiting for database to be ready..."
while ! ${dbcmd} -e "show databases;" > /dev/null 2>&1; do
  sleep 1
done
echo "Database ready!"

counttables=$(echo 'SHOW TABLES' | ${dbcmd} "$DB_DATABASE" | wc -l)

if [ "${counttables}" -eq "0" ]; then
  echo "Updating database schema..."
  php build-base.php

  echo "Creating admin user..."
  php adduser.php ${GUI_USERNAME} ${GUI_PASSWORD} 10 librenms@librenms.docker
fi