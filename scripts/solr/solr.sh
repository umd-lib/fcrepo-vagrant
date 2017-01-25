#!/bin/bash

SERVICE_USER_GROUP=vagrant:vagrant

# https://wiki.duraspace.org/display/FEDORA4x/Solr+Indexing+Quick+Guide#SolrIndexingQuickGuide-Install,ConfigureandStartSolr

# Solr
SOLR_VERSION=6.4.0
SOLR_TGZ=/apps/dist/solr-${SOLR_VERSION}.tgz
# look for a cached tarball
if [ ! -e "$SOLR_TGZ" ]; then
    SOLR_PKG_URL=http://archive.apache.org/dist/lucene/solr/${SOLR_VERSION}/solr-${SOLR_VERSION}.tgz
    curl -Lso "$SOLR_TGZ" "$SOLR_PKG_URL"
fi
tar xvzf "$SOLR_TGZ" --directory /apps

SOLR_HOME=/apps/solr-${SOLR_VERSION}

# SSL

# only generate this cert once then cache in /apps/dist; that way there won't be
# repeated prompts to enable a security exception in the browser
if [ ! -e /apps/dist/solr-ssl.keystore.jks ]; then
    keytool -genkeypair -alias solr-ssl -keyalg RSA -keysize 2048 \
        -keypass changeme -storepass changeme -validity 9999 \
        -keystore /apps/dist/solr-ssl.keystore.jks \
        -ext SAN=DNS:localhost,DNS:solrlocal,IP:192.168.40.11,IP:127.0.0.1 \
        -dname "CN=solrlocal, OU=SSDR, O=UMD Libraries, L=College Park, ST=MD, C=US"
fi

cp /apps/dist/solr-ssl.keystore.jks "$SOLR_HOME"

ln -s "$SOLR_HOME" /apps/solr

mkdir -p /apps/ca

chown -R "$SERVICE_USER_GROUP" "$SOLR_HOME" /apps/ca
