#!/bin/bash

SERVICE_USER_GROUP=vagrant:vagrant

# runtime environment
mkdir -p /apps/fedora/apache/{bin,logs,run}
chown -R "$SERVICE_USER_GROUP" /apps/fedora/apache

# symlink to system modules
ln -sf /usr/lib64/httpd/modules /apps/fedora/apache/modules

# compile the helper setuid program
cp /usr/sbin/apachectl /apps/fedora/apache/bin/apachectl.exec
sudo chown root:root /apps/fedora/apache/bin/apachectl.exec
cd /apps/fedora/apache/src
make SERVICE_USER=vagrant SERVICE_GROUP=vagrant install
