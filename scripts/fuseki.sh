#!/bin/bash

SERVICE_USER_GROUP=vagrant:vagrant

# Fuseki
FUSEKI_VERSION=1.1.1
FUSEKI_TGZ=/apps/dist/jena-fuseki-${FUSEKI_VERSION}-distribution.tar.gz
# look for a cached tarball
if [ ! -e "$FUSEKI_TGZ" ]; then
    FUSEKI_PKG_URL=https://archive.apache.org/dist/jena/binaries/jena-fuseki-${FUSEKI_VERSION}-distribution.tar.gz
    curl -Lso "$FUSEKI_TGZ" "$FUSEKI_PKG_URL"
fi
mkdir -p /apps/fedora/fuseki
tar xvzf "$FUSEKI_TGZ" --directory /apps/fedora/fuseki --strip-components 1

chown -R "$SERVICE_USER_GROUP" /apps/fedora/fuseki
