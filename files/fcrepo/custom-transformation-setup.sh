#!/bin/bash

transformation_file=/apps/fedora/config/custom-transformation.txt

curl -k -X PUT "https://localhost:9601/fcrepo/rest/fedora:system" --key /apps/fedora/ssl/backup-client.key --cert /apps/fedora/ssl/backup-client.pem -o /dev/null -s
status=$(curl -k -X PUT  -H "Content-Type: application/rdf+ldpath" --data-binary "@$transformation_file" "https://localhost:9601/fcrepo/rest/fedora:system/fedora:transform/fedora:ldpath/custom/fedora:Container" -s -w "%{http_code}" --key /apps/fedora/ssl/backup-client.key --cert /apps/fedora/ssl/backup-client.pem -o /dev/null)

if [ $status == 201 ] ;
then
  echo "Added custom transformation!" 
else
  echo "Adding custom transformation failed"
  exit 1
fi

KARAF_HOME=/apps/fedora/karaf
$KARAF_HOME/bin/client -f /apps/fedora/config/karaf-solr-custom-tranformation-config

if [ $? == 0 ] ;
then
  echo "Configured solr indexer in karaf to use the custom transformation!" 
else
  echo "Configuring solr indexer failed!"
  exit 1
fi
echo
