#!/bin/bash
#
# Mattermost for Vagrant
# provisioner script
#

set -eu

#--------------------------------------
# Configurations
#--------------------------------------

SYSTEM_LOCALE=en_US.utf8
SYSTEM_TIMEZONE=Asia/Tokyo

# CentOS 7 official box uses rsync folder for $HOME/sync
export SYNC_DIR=/home/vagrant/sync
export PROVISIONER_DIR=${SYNC_DIR}/provisioner

# Applications (See provisioner/*.sh)
export PROV_MATTERMOST_VERSION=3.2.0
export PROV_MATTERMOST_USER=mattermost
export PROV_DB_NAME=mattermost
export PROV_DB_USER=mmuser
export PROV_DB_PASS=mmuser_password
export PROV_RUBY_VERSION=2.3.1
export PROV_GO_VERSION=1.6.3


#--------------------------------------
# Base
#--------------------------------------

# locale and timezone
localectl set-locale LANG=$SYSTEM_LOCALE
timedatectl set-timezone $SYSTEM_TIMEZONE

# man
yum -y install man man-pages man-pages-ja

# dkms
yum -y install epel-release
yum -y install dkms

# update all
yum -y update

# chrony
yum -y install chrony
systemctl enable chronyd
systemctl start chronyd

# other softwares
yum -y install zsh vim git patch wget screen tree the_silver_searcher
cp /etc/skel/.zshrc /home/vagrant
chown vagrant:vagrant /home/vagrant/.zshrc

# disable firewall, this is development environment
systemctl stop firewalld
systemctl disable firewalld


#--------------------------------------
# Applications
#--------------------------------------

# Workaround for permissions on Windows host
chmod u+x "${PROVISIONER_DIR}"/*.sh

# PostgreSQL
"$PROVISIONER_DIR/postgresql.sh"
"$PROVISIONER_DIR/postgresql-mattermost.sh"

# Mattermost
"$PROVISIONER_DIR/mattermost.sh"

# Nginx
# TODO

# redis for hubot
"$PROVISIONER_DIR/redis.sh"

# rbenv
"$PROVISIONER_DIR/rbenv.sh"

# ruby for lita
"$PROVISIONER_DIR/ruby.sh"

# node.js for hubot
"$PROVISIONER_DIR/nodejs.sh"

# golang
"$PROVISIONER_DIR/golang.sh"


#--------------------------------------
# Utilities
#--------------------------------------

# tig (latest version instead of epel version)
"$PROVISIONER_DIR/tig.sh"

# tmux
"$PROVISIONER_DIR/tmux.sh"

# direnv
"$PROVISIONER_DIR/direnv.sh"


#--------------------------------------
# User defined provisioner
#--------------------------------------

if [[ -f "${SYNC_DIR}/user-provisioner.sh" ]]; then
    # /bin/sh "${SYNC_DIR}/user-provisioner.sh"

    # Workaround for permissions and shebang
    chmod u+x "${SYNC_DIR}/user-provisioner.sh"
    "${SYNC_DIR}/user-provisioner.sh"
fi


#--------------------------------------
# Cleanup
#--------------------------------------

# clean yum cache
yum clean all
