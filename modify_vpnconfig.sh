#!/bin/bash

# Exit if any command fails
set -e

# Input variables
VPNCONFIG_FILE="vpnconfig.ovpn"
CLIENT_CERT_FILE="AzureClientCert.crt"
CLIENT_KEY_FILE="AzureClientCert.key"

# Verify required files exist
if [ ! -f "$VPNCONFIG_FILE" ]; then
  echo "Error: VPN configuration file $VPNCONFIG_FILE not found."
  exit 1
fi

if [ ! -f "$CLIENT_CERT_FILE" ]; then
  echo "Error: Client certificate file $CLIENT_CERT_FILE not found."
  exit 1
fi

if [ ! -f "$CLIENT_KEY_FILE" ]; then
  echo "Error: Client key file $CLIENT_KEY_FILE not found."
  exit 1
fi

# Backup the original VPN config file
cp "$VPNCONFIG_FILE" "$VPNCONFIG_FILE.bak"

# Prepare updated configuration
awk -v cert_content="$(cat $CLIENT_CERT_FILE)" \
    -v key_content="$(cat $CLIENT_KEY_FILE)" '
    BEGIN { cert_start=0; key_start=0 }
    /<cert>/ {
        cert_start=1
        print "<cert>"
        print cert_content
        next
    }
    /<\/cert>/ {
        cert_start=0
        print "</cert>"
        next
    }
    /<key>/ {
        key_start=1
        print "<key>"
        print key_content
        next
    }
    /<\/key>/ {
        key_start=0
        print "</key>"
        next
    }
    cert_start == 0 && key_start == 0 { print $0 }
' "$VPNCONFIG_FILE" > "$VPNCONFIG_FILE.tmp"

# Overwrite the original configuration file with the updated version
mv "$VPNCONFIG_FILE.tmp" "$VPNCONFIG_FILE"

# Confirm completion
echo "VPN configuration file $VPNCONFIG_FILE has been updated with the client certificate and key."