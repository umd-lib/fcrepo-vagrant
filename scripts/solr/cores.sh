#!/bin/bash

SERVICE_USER_GROUP=vagrant:vagrant
SOLR_HOME=/apps/solr/solr
CORES_DIR="$SOLR_HOME/cores"
mkdir -p "$CORES_DIR"

[ -e "$CORES_DIR/fedora4" ] && rm -rf "$CORES_DIR/fedora4"
cp -r /apps/git/fedora4-core "$CORES_DIR/fedora4"

chown -R "$SERVICE_USER_GROUP" "$CORES_DIR"
