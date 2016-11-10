#! /bin/bash

echo "1. Add access control to allow read access for iiif user to fedora"
/apps/fedora/scripts/add-iiif-acl.sh

# Check Karaf startup completed before updating the configuration
echo "2. Add custom transform for solr indexing to karaf"
attempt=0
period=10

/apps/fedora/karaf/bin/client bundle:info fcrepo-indexing-solr > /dev/null
status=$?

while [ "$attempt" -le "6" ]; do
  if [ "$status" -eq "0" ]; then
    /apps/fedora/scripts/custom-transformation-setup.sh
    exit 0;
  else
    attempt=$((attempt + 1))
    wait_time=$((attempt * period))
    echo "Waiting for fcrepo-indexing-solr bundle startup to complete... Next attempt in $wait_time"
    sleep $wait_time
    /apps/fedora/karaf/bin/client bundle:info fcrepo-indexing-solr > /dev/null
    status=$?
  fi
done

echo "Karaf fcrepo-indexing-solr bundle startup did not complete! Please add custom transform for solr indexing manually!"
exit 1;