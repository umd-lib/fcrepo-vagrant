#!/bin/bash

FCREPO_URL=https://localhost:9601/fcrepo/rest
KEY_PATH=/apps/fedora/ssl/backup-client.key
CERT_PATH=/apps/fedora/ssl/backup-client.pem
CONTENT_TYPE="Content-Type: text/turtle"

# Turtle data for repo-viewers group
read -r -d '' REPO_VIEWERS << EOM
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
<> a foaf:Group ;
   foaf:member "CN=iiif" .
EOM

# Turtle data for repository-root acl
read -r -d '' REPO_ROOT_ACL << EOM
PREFIX webac: <http://fedora.info/definitions/v4/webac#>
<> a webac:Acl .
EOM

# Turtle data for repository-root read authorization
read -r -d '' READ_AUTH << EOM
PREFIX acl: <http://www.w3.org/ns/auth/acl#>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
<> a acl:Authorization ;
   acl:agentClass <../../groups/repo-viewers> ;
   acl:mode acl:Read ;
   acl:accessTo <../..> .
EOM

# Sparql data for setting up accessControl for root
read -r -d '' ROOT_ACL << EOM
PREFIX acl: <http://www.w3.org/ns/auth/acl#>
INSERT {
  <> acl:accessControl <./acls/repository-root> .
}
WHERE {}
EOM

# Create the repo-viewers group with CN=iiif user as a member
curl -k --key $KEY_PATH --cert $CERT_PATH -X PUT "$FCREPO_URL/groups"
echo
curl -k --key $KEY_PATH --cert $CERT_PATH -X PUT -H "$CONTENT_TYPE" --data "$REPO_VIEWERS"  "$FCREPO_URL/groups/repo-viewers"

# Create the acl and authorization to allow read access to the entire repository for the repo-viewers group.
curl -k --key $KEY_PATH --cert $CERT_PATH -X PUT "$FCREPO_URL/acls"
echo
curl -k --key $KEY_PATH --cert $CERT_PATH -X PUT -H "$CONTENT_TYPE" --data "$REPO_ROOT_ACL"  "$FCREPO_URL/acls/repository-root"
echo
curl -k --key $KEY_PATH --cert $CERT_PATH -X PUT -H "$CONTENT_TYPE" --data "$READ_AUTH"  "$FCREPO_URL/acls/repository-root/read"
echo

# Configure root to use the ACL
SPARQL_CONT_TYPE="Content-Type: application/sparql-update"
curl -k --key $KEY_PATH --cert $CERT_PATH  -X PATCH  -H "$SPARQL_CONT_TYPE" --data "$ROOT_ACL"  "$FCREPO_URL"
echo

