#!/bin/bash

SERVICE_USER_GROUP=vagrant:vagrant

# Fuseki
FUSEKI_VERSION=2.3.1
FUSEKI_TGZ=/apps/dist/apache-jena-fuseki-${FUSEKI_VERSION}.tar.gz
# look for a cached tarball
if [ ! -e "$FUSEKI_TGZ" ]; then
    FUSEKI_PKG_URL=https://archive.apache.org/dist/jena/binaries/apache-jena-fuseki-${FUSEKI_VERSION}.tar.gz
    curl -Lso "$FUSEKI_TGZ" "$FUSEKI_PKG_URL"
fi
tar xvzf "$FUSEKI_TGZ" --directory /apps

FUSEKI_BASE=/apps/fedora/fuseki
mkdir -p "$FUSEKI_BASE"/{DB,logs}

chown -R "$SERVICE_USER_GROUP" "$FUSEKI_BASE"
