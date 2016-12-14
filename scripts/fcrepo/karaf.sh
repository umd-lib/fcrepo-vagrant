#!/bin/bash

SERVICE_USER_GROUP=vagrant:vagrant

# Karaf
KARAF_VERSION=4.0.4
KARAF_TGZ=/apps/dist/apache-karaf-${KARAF_VERSION}.tar.gz
# look for a cached tarball
if [ ! -e "$KARAF_TGZ" ]; then
    KARAF_PKG_URL=https://archive.apache.org/dist/karaf/${KARAF_VERSION}/apache-karaf-${KARAF_VERSION}.tar.gz
    curl -Lso "$KARAF_TGZ" "$KARAF_PKG_URL"
fi
KARAF_HOME=/apps/fedora/karaf
mkdir -p "$KARAF_HOME"
# exclude the /etc directory, since we have our own customizations in the fcrepo-env
tar xvzf "$KARAF_TGZ" --directory "$KARAF_HOME" --strip-components 1 --exclude etc

chown -R "$SERVICE_USER_GROUP" "$KARAF_HOME"
