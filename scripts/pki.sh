#!/bin/bash

# For some reason, `whichopensslcnf` doesn't find the openssl.cnf file (at least on Ubuntu 18.04)
# A few versioned ones are included though (format: openssl-${version}.cnf), so we symlink one of those
if [ ! -f /usr/share/easy-rsa/openssl.cnf ]; then
    OPENSSL_CNF=$(ls /usr/share/easy-rsa | grep 'openssl-.*.cnf' | sort -r | head -n 1)
    sudo ln -s "$OPENSSL_CNF" /usr/share/easy-rsa/openssl.cnf
fi

sudo cp -R /usr/share/easy-rsa /etc/openvpn/.

# Rather than execute the vars dir, lets just define them here:
export EASY_RSA="/etc/openvpn/easy-rsa/"
export OPENSSL="openssl"
export PKCS11TOOL="pkcs11-tool"
export GREP="grep"
export KEY_CONFIG=`$EASY_RSA/whichopensslcnf $EASY_RSA`
export KEY_DIR="$EASY_RSA/keys"
export PKCS11_MODULE_PATH="dummy"
export PKCS11_PIN="dummy"
export KEY_SIZE="${KEY_SIZE:-2048}"
export CA_EXPIRE=3650
export KEY_EXPIRE=3650

# These are the fields which will be placed in the certificate.
# Don't leave any of these fields blank. Update if you want
export KEY_COUNTRY="US"
export KEY_PROVINCE="CA"
export KEY_CITY="SanFrancisco"
export KEY_ORG="Fort-Funston"
export KEY_EMAIL="noreply@getlost.com"
export KEY_OU="MyOrganizationalUnit"
export KEY_NAME="$CLIENT_NAME"
# END OF vars

. /etc/openvpn/easy-rsa/clean-all
. /etc/openvpn/easy-rsa/build-ca

# create the server key
. /etc/openvpn/easy-rsa/build-key-server server


# Create the client Key, update these if you want. The details MUST be slightly diff to server
export KEY_COUNTRY="US"
export KEY_PROVINCE="TX"
export KEY_CITY="Austin"
export KEY_ORG="The Alamo"
export KEY_EMAIL="noreply@getlost2.com"
export KEY_CN=changeme
export KEY_NAME=keyname
export KEY_OU=noidea
export PKCS11_MODULE_PATH=changeme
export PKCS11_PIN=1234
. /etc/openvpn/easy-rsa/build-key $CLIENT_NAME

# generate Deffie Hellman Parameters
. /etc/openvpn/easy-rsa/build-dh

OLD_PWD=$(pwd)

# Move the keys we just generated to the directory that actually runs the openvpn service
cd /etc/openvpn/easy-rsa/keys
cp ca.crt ca.key "$CLIENT_NAME.key" "$CLIENT_NAME.crt" "dh$KEY_SIZE.pem" server.crt server.key /etc/openvpn

# Generate a key for tls-auth
cd /etc/openvpn
openvpn --genkey --secret ta.key

cd "$OLD_PWD"