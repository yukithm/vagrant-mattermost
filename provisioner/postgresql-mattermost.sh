#!/bin/bash -eu
#--------------------------------------
# Database
#
# Environment Variables:
#   PROV_DB_USER: user name
#   PROV_DB_PASS: password for user
#   PROV_DB_NAME: database name
#--------------------------------------

: ${PROV_DB_USER:=${1:-mmuser}}
: ${PROV_DB_PASS:=${2:-mmuser_password}}
: ${PROV_DB_NAME:=${3:-mattermost}}

# Create user
# Need CREATEDB for Rails
sudo -u postgres psql <<SQL
CREATE DATABASE ${PROV_DB_NAME};
CREATE USER ${PROV_DB_USER} CREATEDB ENCRYPTED PASSWORD '${PROV_DB_PASS}';
GRANT ALL PRIVILEGES ON DATABASE ${PROV_DB_NAME} to ${PROV_DB_USER};
SQL
