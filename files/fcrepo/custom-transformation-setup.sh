#!/bin/bash

container_transformation_file=/apps/fedora/config/custom-container-transformation.txt
binary_transformation_file=/apps/fedora/config/custom-binary-transformation.txt

FCREPO_URL=https://localhost:9601/fcrepo/rest
KEY_PATH=/apps/fedora/ssl/backup-client.key
CERT_PATH=/apps/fedora/ssl/backup-client.pem

curl -k -X PUT "$FCREPO_URL/fedora:system" --key $KEY_PATH --cert $CERT_PATH -o /dev/null -s
curl -k -X PUT "$FCREPO_URL/fedora:system/fedora:transform/fedora:ldpath/custom/" --key $KEY_PATH --cert $CERT_PATH -o /dev/null -s

CONTENT_TYPE="Content-Type: application/rdf+ldpath"
CONTAINER_PATH=fedora:system/fedora:transform/fedora:ldpath/custom/fedora:Container
BINARY_PATH=fedora:system/fedora:transform/fedora:ldpath/custom/fedora:Binary

container_status=$(curl -k -X PUT  -H "$CONTENT_TYPE" --data-binary "@$container_transformation_file" "$FCREPO_URL/$CONTAINER_PATH" -s -w "%{http_code}" --key $KEY_PATH --cert $CERT_PATH -o /dev/null)
binary_status=$(curl -k -X PUT  -H "$CONTENT_TYPE" --data-binary "@$binary_transformation_file" "$FCREPO_URL/$BINARY_PATH" -s -w "%{http_code}" --key $KEY_PATH --cert $CERT_PATH -o /dev/null)

if ([ $container_status == 201 ] || [ $container_status == 204 ]) && ([ $binary_status == 201 ] || [ $container_status == 204 ]) ;
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
