#!/bin/bash

# Set variables
ROOT_CERT_NAME="AzureRootCert"
ROOT_CERT_KEY="AzureRootCert.key"
ROOT_CERT_FILE="AzureRootCert.pem"

# Create a private key
openssl genrsa -out $ROOT_CERT_KEY 2048

# Create a root certificate
openssl req -x509 -new -nodes -key $ROOT_CERT_KEY -sha256 -days 3650 \
  -out $ROOT_CERT_FILE \
  -subj "/C=US/ST=YourState/L=YourCity/O=YourOrg/OU=YourUnit/CN=$ROOT_CERT_NAME"

# Display the certificate
echo "Root certificate created: $ROOT_CERT_FILE"
echo "You can now upload this root certificate to Azure."
cat $ROOT_CERT_FILE
