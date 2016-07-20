#!/bin/bash -eu
#--------------------------------------
# Database
#
# Environment Variables:
#   PROV_DB_USER: user name
#   PROV_DB_ENCODING: database encoding (for initdb)
#   PROV_DB_LOCALE: database locale (for initdb)
#--------------------------------------

: ${PROV_DB_USER:=${1:-vagrant}}
: ${PROV_DB_ENCODING:=UTF8}
: ${PROV_DB_LOCALE:=C}

# yum -y install postgresql postgresql-server postgresql-devel

# Need v9.4+
yum -y install http://yum.postgresql.org/9.4/redhat/rhel-6-x86_64/pgdg-redhat94-9.4-1.noarch.rpm
yum -y install postgresql94-server postgresql94-contrib

PGSETUP_BIN=/usr/pgsql-9.4/bin/postgresql94-setup
PGSETUP_INITDB_OPTIONS="--encoding=${PROV_DB_ENCODING} --locale=${PROV_DB_LOCALE}" "$PGSETUP_BIN" initdb

# Add authentication
sed -i -e "/^# \"local\"/a\local   all             ${PROV_DB_USER}                                md5" /var/lib/pgsql/9.4/data/pg_hba.conf
sed -i -e "/^# IPv4/a\host    all             ${PROV_DB_USER}        localhost               md5" /var/lib/pgsql/9.4/data/pg_hba.conf

systemctl enable postgresql-9.4.service
systemctl start postgresql-9.4.service
