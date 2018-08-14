#!/bin/bash

SERVICE_USER_GROUP=vagrant:vagrant

# Maven
MAVEN_VERSION=3.5.3
MAVEN_TGZ=/apps/dist/apache-maven-${MAVEN_VERSION}-bin.tar.gz
# look for a cached tarball
if [ ! -e "$MAVEN_TGZ" ]; then
    MAVEN_PKG_URL=https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz
    curl -Lso "$MAVEN_TGZ" "$MAVEN_PKG_URL"
fi
tar xvzf "$MAVEN_TGZ" --directory /apps

cat >/etc/profile.d/maven.sh <<END
export M2_HOME=/apps/apache-maven-${MAVEN_VERSION}
export PATH=\${M2_HOME}/bin:\${PATH}
END
