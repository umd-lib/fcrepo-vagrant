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
req_extensions = v3_req

[ fcrepolocal_dn ]
commonName              = fcrepolocal
stateOrProvinceName     = MD
countryName             = US
organizationName        = UMD
organizationalUnitName  = Libraries

[ v3_req ]
subjectAltName = @alt_names

[alt_names]
DNS.1 = fcrepolocal
DNS.2 = localhost
IP.1 = 192.168.40.10
IP.2 = 127.0.0.1
END

# Generate private key 
openssl genrsa -out "$KEY" 2048

# Generate CSR 
openssl req -new -key "$KEY" -out "$CSR" -config "$CNF"

# Generate self-signed cert
openssl x509 -req -days 365 -in "$CSR" -signkey "$KEY" -out "$CRT" \
    -extensions v3_req -extfile "$CNF"
