#!/bin/bash

# export db creds as env variables
export MYSQL_DB_USER=$(/vcap_parse.sh cleardb 0 credentials username)
export MYSQL_DB_PASSWORD=$(/vcap_parse.sh cleardb 0 credentials password)
export MYSQL_DB_URL=$(/vcap_parse.sh cleardb 0 credentials jdbcUrl):3306

# Fix the entry point we overrode earlier (from end of wordpress:latest)
/entrypoint.sh
apache2-foreground
