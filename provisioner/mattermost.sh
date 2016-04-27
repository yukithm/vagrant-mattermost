#--------------------------------------
# Mattermost
#
# Environment Variables:
#   MATTERMOST_VERSION: version (e.g. "2.0.0")
#   MATTERMOST_USER: user name
#   DB_NAME: database name
#   DB_USER: user name for database
#   DB_PASS: password for database
#--------------------------------------

MATTERMOST_VERSION=${MATTERMOST_VERSION:-2.1.0}
MATTERMOST_USER=${MATTERMOST_USER:-mattermost}

yum -y install wget

# Download and deploy Mattermost
mkdir -p /opt/src
pushd /opt/src
wget --quiet "https://github.com/mattermost/platform/releases/download/v${MATTERMOST_VERSION}/mattermost.tar.gz"
tar xf mattermost.tar.gz -C /opt
popd

# Create storage directory for files
mkdir -p /opt/mattermost/data

# Create user and group
useradd --comment="Mattermost" --user-group --shell=/sbin/nologin \
        --system --home-dir="/opt/mattermost" "$MATTERMOST_USER"

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
s/"DataSource": .*/"DataSource": "postgres:\\/\\/${DB_USER}:${DB_PASS}@localhost:5432\\/${DB_NAME}\\?sslmode=disable\\&connect_timeout=10",/
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
