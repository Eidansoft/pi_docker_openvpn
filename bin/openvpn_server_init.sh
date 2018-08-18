#!/bin/bash

# Generate the server authentication request and generate the server private key.
# This script expect the following params:
#    1st The server name

# Load common functions
source openvpn_common_functions.sh

# The server name is mandatory
SVR_NAME=$1
[ "$SVR_NAME" = "" ] && echo "[ERROR] The server name is mandatory." && exit 1

# Avoid override previously existent certificates and keys
check_working_folder_not_exist $FILES_SVR_NAME_FOLDER

# Create and enter into the folder to work with server files
mkdir $FILES_SVR_NAME_FOLDER
pushd $FILES_SVR_NAME_FOLDER

# Creante the initial PKI structure
easyrsa init-pki

# Set the Common Name (CN) at the easyrsa configuration to identify properly the server
echo "set_var EASYRSA_REQ_CN \"VPN Server $SVR_NAME\"" >> /opt/EasyRSA/vars

# Generate the server certificate request
easyrsa gen-req $SVR_NAME nopass

# Clean the easyrsa configuration file to remove the previous changes setting the CN for the server
cp /opt/ca_conf.properties /opt/EasyRSA/vars

# Generate the Diffie-Hellman key
easyrsa gen-dh

# Generate a HMAC signature
openvpn --genkey --secret ta.key

# Save all openvpn service needed files into the recopilation folder
create_folder_if_not_exist ../$FILES_OPENVPN_FOLDER
cp pki/private/$SVR_NAME.key ../$FILES_OPENVPN_FOLDER
cp ta.key ../$FILES_OPENVPN_FOLDER
cp pki/dh.pem ../$FILES_OPENVPN_FOLDER

popd

# Put a summary at the user screen
echo "######################################"
echo ""
echo "Summary:"
echo "You have created a new certificate for your server <$SVR_NAME>."
echo "The certificate request to be signed is at <$FILES_SVR_NAME_FOLDER/pki/reqs/$SVR_NAME.req>"
echo "The server private key is at <$FILES_SVR_NAME_FOLDER/pki/private/$SVR_NAME.key>"
echo "The Diffie-Hellman key is at <$FILES_OPENVPN_FOLDER/dh.pem>."
echo "The HMAC signature is at <$FILES_OPENVPN_FOLDER/ta.key>."
echo "Now you must run the script to sign the server request with your CA."

exit 0
