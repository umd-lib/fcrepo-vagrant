#!/bin/bash

KARAF_HOME=/apps/fedora/karaf

$KARAF_HOME/bin/start
# wait for server to start running
# 5 seconds appears to be sufficient
sleep 5
$KARAF_HOME/bin/client -f /apps/fedora/config/karaf-fcrepo-setup
$KARAF_HOME/bin/stop

# force removal of lock file
rm $KARAF_HOME/lock
