#!/bin/bash

SERVICE_USER_GROUP=vagrant:vagrant
SOLR_HOME=/apps/solr/solr

[ -e "$SOLR_HOME/fedora4" ] && rm -rf "$SOLR_HOME/fedora4"
cp -r /apps/git/fedora4-core "$SOLR_HOME/fedora4"
chown -R "$SERVICE_USER_GROUP" "$SOLR_HOME/fedora4"
