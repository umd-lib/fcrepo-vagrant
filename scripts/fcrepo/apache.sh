#!/bin/bash

SERVICE_USER=vagrant
SERVICE_GROUP=vagrant

# runtime environment
mkdir -p /apps/fedora/apache/{bin,logs,run}
mkdir -p /apps/fedora/apache/tmp/cas
chown -R "${SERVICE_USER}:${SERVICE_GROUP}" /apps/fedora/apache

# symlink to system modules
ln -sf /usr/lib64/httpd/modules /apps/fedora/apache/modules

# compile the helper setuid program
rm /apps/fedora/apache/src/apachectl
cp /usr/sbin/apachectl /apps/fedora/apache/bin/apachectl.exec
sudo chown root:root /apps/fedora/apache/bin/apachectl.exec
cd /apps/fedora/apache/src
make SERVICE_USER="$SERVICE_USER" SERVICE_GROUP="$SERVICE_GROUP" install clean
