#!/bin/bash

# OpenJDK
yum install -y java-1.8.0-openjdk-devel

# Find the newly extracted JDK
JAVA_HOME=$(dirname $(dirname $(readlink $(readlink $(which javac)))))
ln -s "$JAVA_HOME" /apps/java
cat > /etc/profile.d/java.sh <<END
export JAVA_HOME=$JAVA_HOME
export PATH=\$JAVA_HOME/bin:\$PATH
END
