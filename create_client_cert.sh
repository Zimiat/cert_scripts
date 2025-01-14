#!/bin/bash

# Variables
ROOT_CERT_KEY="AzureRootCert.key"
ROOT_CERT_FILE="AzureRootCert.pem"
CLIENT_CERT_NAME="AzureClientCert"
CLIENT_CERT_KEY="${CLIENT_CERT_NAME}.key"
CLIENT_CERT_CSR="${CLIENT_CERT_NAME}.csr"
CLIENT_CERT_FILE="${CLIENT_CERT_NAME}.crt"
CLIENT_EXT_FILE="client_ext.cnf"

# Generate client private key
openssl genrsa -out $CLIENT_CERT_KEY 2048

# Create a certificate signing request (CSR) for the client
openssl req -new -key $CLIENT_CERT_KEY -out $CLIENT_CERT_CSR \
  -subj "/C=US/ST=YourState/L=YourCity/O=YourOrg/OU=YourUnit/CN=$CLIENT_CERT_NAME"

# Create a configuration file for the EKU
cat <<EOF > $CLIENT_EXT_FILE
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
extendedKeyUsage = clientAuth
EOF

# Sign the client certificate with the root certificate, including the EKU
openssl x509 -req -in $CLIENT_CERT_CSR -CA $ROOT_CERT_FILE -CAkey $ROOT_CERT_KEY -CAcreateserial \
  -out $CLIENT_CERT_FILE -days 365 -sha256 -extfile $CLIENT_EXT_FILE -extensions v3_req

# Clean up
rm -f $CLIENT_CERT_CSR $CLIENT_EXT_FILE

echo "Client certificate created: $CLIENT_CERT_FILE"