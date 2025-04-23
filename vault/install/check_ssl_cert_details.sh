#!/bin/bash

CERT_DIR="${1:-./certs}"  # Default directory unless specified

echo "🔹 Checking certificates in: $CERT_DIR"
echo "--------------------------------------------------"

for CERT_FILE in "$CERT_DIR"/*.crt; do
    if [[ -f "$CERT_FILE" ]]; then
        echo "📜 File: $(basename "$CERT_FILE")"

        # Get Subject (CN)
        CN=$(openssl x509 -in "$CERT_FILE" -text -noout | grep "Subject:" | sed -E 's/.*CN = (.*)/\1/')
        echo "   🔹 CN: $CN"

        # Get Issuer
        ISSUER=$(openssl x509 -in "$CERT_FILE" -text -noout | grep "Issuer:" | sed -E 's/.*CN = (.*)/\1/')
        echo "   🔹 Issued By: $ISSUER"

        # Check Expiration Date
        EXPIRY=$(openssl x509 -in "$CERT_FILE" -enddate -noout | cut -d= -f2)
        echo "   🔹 Expires On: $EXPIRY"

        # Only check private key for non-CA certificates
        if [[ "$CN" != "$ISSUER" ]]; then
            CERT_MODULUS=$(openssl x509 -noout -modulus -in "$CERT_FILE" | openssl md5)
            KEY_FILE="${CERT_DIR}/private.key"

            if [[ -f "$KEY_FILE" ]]; then
                KEY_MODULUS=$(openssl rsa -noout -modulus -in "$KEY_FILE" | openssl md5)
                if [[ "$CERT_MODULUS" == "$KEY_MODULUS" ]]; then
                    echo "   ✅ Private key matches certificate"
                else
                    echo "   ❌ Private key MISMATCH!"
                fi
            else
                echo "   ⚠️ No private key found in $KEY_FILE"
            fi
        else
            echo "   ⚠️ Skipping private key check for CA certificate"
        fi

        echo "--------------------------------------------------"
    fi
done
