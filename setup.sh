#!/bin/bash
 
DIR_DATASET="/path/to/dataset"

USER="nextcloud"
DB="nextcloud"

# Enable the services.
sysrc nginx_enable="YES"
sysrc php_fpm_enable="YES"
sysrc redis_enable="YES"

sysrc postgresql_enable="YES"
sysrc postgresql_class=postgres
#sysrc postgresql_data="/mnt/postgres/data" #path to be used by the initdb 
 
## Setup postgresql mount.
#mkdir /mnt/postgres
#chown postgres:postgres /mnt/postgres



# Append to login.conf.
cat <<__EOF__ >>/etc/login.conf

postgres:\
	:lang=en_AU.UTF-8:\
	:setenv=LC_COLLATE=C:\
	:tc=default:
__EOF__

cap_mkdb /etc/login.conf
postgresql_class="postgres"


service postgresql initdb



# /etc/postgresql/9.3/main/pg_hba.conf



cp /usr/local/etc/php.ini-production /usr/local/etc/php.ini




 
if [ ! -d "/usr/local/www/nextcloud/tmp" ] ; then
	mkdir -p /usr/local/www/nextcloud/tmp
fi
chown -R www:www /usr/local/www/nextcloud/tmp
 
# Start the services.
service nginx start
service php-fpm start
service postgresql start
service redis start
 
# Save the config values
echo "$DB" > /root/dbname
echo "$USER" > /root/dbuser
export LC_ALL=C
cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1 > /root/dbpassword
PASS=`cat /root/dbpassword`
 
echo "Database Name: $DB"
echo "Database User: $USER"
echo "Database Password: $PASS"
 

#psql -U postgres "CREATE USER '${USER}' WITH PASSWORD '${PASS}';"
#psql -U postgres "CREATE DATABASE ${DB} TEMPLATE template0 ENCODING 'UNICODE';"
#psql -U postgres "ALTER DATABASE ${DB} OWNER TO ${USER};"
#psql -U postgres "GRANT ALL PRIVILEGES ON DATABASE ${DB} TO ${USER};"

psql -U postgres <<SQL
CREATE USER '${USER}' WITH PASSWORD '${PASS}';
CREATE DATABASE ${DB} TEMPLATE template0 ENCODING 'UNICODE';
ALTER DATABASE ${DB} OWNER TO ${USER};
GRANT ALL PRIVILEGES ON DATABASE ${DB} TO ${USER};
SQL


 
mkdir -p /usr/local/www/nextcloud/tmp >/dev/null 2>/dev/null
chmod o-rwx /usr/local/www/nextcloud/tmp
