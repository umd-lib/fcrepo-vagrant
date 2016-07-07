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
tar xvzf "$KARAF_TGZ" --directory "$KARAF_HOME" --strip-components 1

chown -R "$SERVICE_USER_GROUP" "$KARAF_HOME"

### setting up /apps/fedora/karaf
#mkdir -p /apps/fedora/karaf/etc
#cp -rp "$KARAF_HOME/etc" /apps/fedora/karaf
#mkdir -p /apps/fedora/karaf/data
#chown -R "$SERVICE_USER_GROUP" /apps/fedora/karaf


### fcrepo camel setup (https://wiki.duraspace.org/display/FEDORA4x/Setup+Camel+Message+Integrations)
#sudo -u vagrant "$KARAF_HOME/bin/karaf" -f - <<END
#feature:repo-add camel 2.14.0
#feature:repo-add activemq 5.10.0
#feature:install camel
#feature:install activemq-camel
#
## display available camel features
#feature:list | grep camel
#
## install camel features, as needed
#feature:install camel-http4
#
## install fcrepo-camel (as of v4.1.0)
#feature:repo-add mvn:org.fcrepo.camel/fcrepo-camel/LATEST/xml/features
#feature:install fcrepo-camel
#END
