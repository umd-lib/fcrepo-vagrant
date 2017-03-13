#!/bin/bash

SERVICE_USER_GROUP=vagrant:vagrant
SOLR_HOME=/apps/solr/solr
CORES_DIR="$SOLR_HOME/cores"
mkdir -p "$CORES_DIR"

CORE_SRC=$1
CORE_NAME=${2:-$(basename "$CORE_SRC")}

[ -e "$CORES_DIR/$CORE_NAME" ] && rm -rf "$CORES_DIR/$CORE_NAME"
if [ -d "$CORE_SRC/.git" ]; then
    # if the core source is a Git repo, clone it
    git clone "file://$CORE_SRC/.git" "$CORES_DIR/$CORE_NAME"
else
    # otherwise, just do a recursive copy
    cp -r "$CORE_SRC" "$CORES_DIR/$CORE_NAME"
fi

chown -R "$SERVICE_USER_GROUP" "$CORES_DIR"
