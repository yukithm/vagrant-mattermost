#!/bin/bash -eu
#--------------------------------------
# Mattermost
#
# Environment Variables:
#   PROV_MATTERMOST_VERSION: version (e.g. "3.2.0")
#   PROV_MATTERMOST_USER: user name
#   PROV_DB_NAME: database name
#   PROV_DB_USER: user name for database
#   PROV_DB_PASS: password for database
#--------------------------------------

: ${PROV_MATTERMOST_VERSION:=${1:-3.2.0}}
: ${PROV_MATTERMOST_USER:=${2:-mattermost0}}

yum -y install wget

# Download and deploy Mattermost
mkdir -p /opt/src
pushd /opt/src
tarball=mattermost-team-${PROV_MATTERMOST_VERSION}-linux-amd64.tar.gz
wget --quiet "https://releases.mattermost.com/${PROV_MATTERMOST_VERSION}/${tarball}"
tar xf "$tarball" -C /opt
popd

# Create storage directory for files
mkdir -p /opt/mattermost/data

# Create user and group
useradd --comment="Mattermost" --user-group --shell=/sbin/nologin \
        --system --home-dir="/opt/mattermost" "$PROV_MATTERMOST_USER"

# Change owner and permissions
chown -R mattermost:mattermost /opt/mattermost
chmod -R g+w /opt/mattermost

# Fix SELinux related problems
chcon -Rt httpd_sys_content_t /opt/mattermost/
setsebool -P httpd_can_network_connect 1

# For management
usermod -aG mattermost vagrant

# Configure Mattermost
sed -i.bak -f - /opt/mattermost/config/config.json <<EOS
s/"DriverName": "mysql"/"DriverName": "postgres"/
s/"DataSource": .*/"DataSource": "postgres:\\/\\/${PROV_DB_USER}:${PROV_DB_PASS}@localhost:5432\\/${PROV_DB_NAME}\\?sslmode=disable\\&connect_timeout=10",/
EOS

cat <<'EOS' >/etc/systemd/system/mattermost.service
[Unit]
Description=Mattermost
After=syslog.target network.target postgresql-9.4.service

[Service]
Type=simple
WorkingDirectory=/opt/mattermost/bin
User=mattermost
ExecStart=/opt/mattermost/bin/platform
PIDFile=/var/spool/mattermost/pid/master.pid

[Install]
WantedBy=multi-user.target
EOS

systemctl daemon-reload
systemctl enable mattermost.service
systemctl start mattermost.service
