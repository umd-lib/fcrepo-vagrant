#!/bin/bash

CLIENT=${1:-client}

#TODO: allow user to specify a password for this cert (P12 and PEM file)
#TODO: need a better location to create client certs
cd /home/vagrant

# CA info
CA_KEY=/apps/fedora/ssl/ca.key
CA_CRT=/apps/fedora/ssl/ca.crt

cat > "$CLIENT".cnf <<END
[ req ]
prompt                  = no
distinguished_name      = client_dn

[ client_dn ]
commonName              = $CLIENT
END

# create a client key and CSR
openssl genrsa -out "$CLIENT".key 2048
openssl req -new -key "$CLIENT".key -out "$CLIENT".csr -config "$CLIENT".cnf

# sign the client cert with our CA
openssl x509 -req -days 3650 -CA "$CA_CRT" -CAkey "$CA_KEY" -CAcreateserial -in "$CLIENT".csr -out "$CLIENT".crt

# package the client key and cert as PKCS12
openssl pkcs12 -export -clcerts -in "$CLIENT".crt -inkey "$CLIENT".key -out "$CLIENT".p12 -passout pass:

# package as a PEM (for curl)
openssl pkcs12 -in "$CLIENT".p12 -out "$CLIENT".pem -passout pass: -passin pass:
