#!/bin/bash

SERVICE_USER_GROUP=vagrant:vagrant

# Infinispan
INFINISPAN_VERSION=8.0.2.Final
INFINISPAN_ZIP=/apps/dist/infinispan-server-${INFINISPAN_VERSION}-bin.zip
# look for a cached zipfile
if [ ! -e "$INFINISPAN_ZIP" ]; then
    INFINISPAN_PKG_URL=http://downloads.jboss.org/infinispan/${INFINISPAN_VERSION}/infinispan-server-${INFINISPAN_VERSION}-bin.zip
    curl -Lso "$INFINISPAN_ZIP" "$INFINISPAN_PKG_URL"
fi
unzip "$INFINISPAN_ZIP" -d /apps/fedora
mv /apps/fedora/infinispan-server-${INFINISPAN_VERSION} /apps/fedora/infinispan-server

chown -R "$SERVICE_USER_GROUP" /apps/fedora/infinispan-server
