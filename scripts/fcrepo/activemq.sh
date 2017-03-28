#!/bin/bash

SERVICE_USER_GROUP=vagrant:vagrant

# Activemq
ACTIVEMQ_VERSION=5.14.3
ACTIVEMQ_TGZ=/apps/dist/apache-activemq-${ACTIVEMQ_VERSION}-bin.tar.gz
# look for a cached tarball
if [ ! -e "$ACTIVEMQ_TGZ" ]; then
    ACTIVEMQ_PKG_URL=http://archive.apache.org/dist/activemq/${ACTIVEMQ_VERSION}/apache-activemq-${ACTIVEMQ_VERSION}-bin.tar.gz
    curl -Lso "$ACTIVEMQ_TGZ" "$ACTIVEMQ_PKG_URL"
fi
tar xvzf "$ACTIVEMQ_TGZ" --directory /apps

ACTIVEMQ_HOME=/apps/apache-activemq-${ACTIVEMQ_VERSION}
# for some reason, ActiveMQ requires that its lib directory be owned by the
# user who starts the ActiveMQ broker process
chown -R "$SERVICE_USER_GROUP" "$ACTIVEMQ_HOME/lib"
