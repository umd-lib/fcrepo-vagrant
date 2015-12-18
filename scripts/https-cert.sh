#!/bin/bash

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
