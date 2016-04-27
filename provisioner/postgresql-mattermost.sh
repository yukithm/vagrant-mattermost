#--------------------------------------
# Database
#
# Environment Variables:
#   DB_NAME: database name
#   DB_USER: user name
#   DB_PASS: password for user
#--------------------------------------

DB_NAME=${DB_NAME:-mattermost}
DB_USER=${DB_USER:-mmuser}
DB_PASS=${DB_PASS:-mmuser_password}

# Create user
# Need CREATEDB for Rails
sudo -u postgres psql <<SQL
CREATE DATABASE ${DB_NAME};
CREATE USER ${DB_USER} CREATEDB ENCRYPTED PASSWORD '${DB_PASS}';
GRANT ALL PRIVILEGES ON DATABASE ${DB_NAME} to ${DB_USER};
SQL
