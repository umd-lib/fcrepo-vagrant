#! /bin/bash

echo "Add custom transform for solr indexing"
/apps/fedora/scripts/custom-transformation-setup.sh

echo "Add access control to allow read access for iiif user"
/apps/fedora/scripts/add-iiif-acl.sh
