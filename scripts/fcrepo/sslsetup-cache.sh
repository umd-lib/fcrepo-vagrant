#!/bin/bash

CACHED_CA_CONF=/apps/dist/ca

if [ -e "$CACHED_CA_CONF" ]; then
    echo "Using CA cached in dist/ca"
    cp -p $CACHED_CA_CONF/* /apps/fedora/ssl/
    cd /apps/fedora/scripts && ./sslsetup.sh
else
    cd /apps/fedora/scripts && ./sslsetup.sh
    echo "Caching CA to dist/ca"
    mkdir /apps/dist/ca
    cp -p /apps/fedora/ssl/ca.* $CACHED_CA_CONF
fi
