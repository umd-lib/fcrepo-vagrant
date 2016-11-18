#!/bin/bash

SERVICE_USER_GROUP=vagrant:vagrant
CORES_DIR=/apps/solr/example/solr

[ -e "$CORES_DIR/fedora4" ] && rm -rf "$CORES_DIR/fedora4"
cp -r /apps/git/fedora4-core "$CORES_DIR/fedora4"
chown -R "$SERVICE_USER_GROUP" "$CORES_DIR/fedora4"
