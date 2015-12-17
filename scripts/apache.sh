#!/bin/bash

SERVICE_USER_GROUP=vagrant:vagrant

mkdir -p /apps/fedora/apache/{bin,logs,run}
chown -R "$SERVICE_USER_GROUP" /apps/fedora/apache

ln -s /usr/lib64/httpd/modules /apps/fedora/apache/modules
cp /usr/sbin/apachectl /apps/fedora/apache/bin/apachectl.exec
sudo chown root:root /apps/fedora/apache/bin/apachectl.exec
cd /apps/fedora/apache/src
make install

# SSL Certificate (self-signed)
mkdir -p /apps/ssl/{key,csr,crt,cnf}

KEY=/apps/ssl/key/fcrepolocal.key
CSR=/apps/ssl/csr/fcrepolocal.csr
CRT=/apps/ssl/crt/fcrepolocal.crt
CNF=/apps/ssl/cnf/fcrepolocal.cnf

cat > "$CNF" <<END
[ req ]
prompt                  = no
distinguished_name      = fcrepolocal_dn

[ fcrepolocal_dn ]
commonName              = fcrepolocal
stateOrProvinceName     = MD
countryName             = US
organizationName        = UMD
organizationalUnitName  = Libraries
END

# Generate private key 
openssl genrsa -out "$KEY" 2048

# Generate CSR 
openssl req -new -key "$KEY" -out "$CSR" -config "$CNF"

# Generate Self Signed Key
openssl x509 -req -days 365 -in "$CSR" -signkey "$KEY" -out "$CRT"
