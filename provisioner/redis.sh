#!/bin/bash -eu
#--------------------------------------
# Redis
#--------------------------------------

yum -y install redis

systemctl enable redis
systemctl start redis
