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

# Create the initial PKI structure
easyrsa --vars=$FILES_OPENVPN_FOLDER/ca_conf.properties init-pki

# Generate the server certificate request
easyrsa --vars=$FILES_OPENVPN_FOLDER/ca_conf.properties --batch --req-cn="VPN Server $SVR_NAME" gen-req $SVR_NAME nopass

# Generate the Diffie-Hellman key
easyrsa --vars=$FILES_OPENVPN_FOLDER/ca_conf.properties gen-dh

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
echo "The certificate request to be signed is at <$PWD/$FILES_SVR_NAME_FOLDER/pki/reqs/$SVR_NAME.req>"
echo "The server private key is at <$PWD/$FILES_SVR_NAME_FOLDER/pki/private/$SVR_NAME.key>"
echo "The Diffie-Hellman key is at <$PWD/$FILES_OPENVPN_FOLDER/dh.pem>."
echo "The HMAC signature is at <$PWD/$FILES_OPENVPN_FOLDER/ta.key>."
echo "Now you must run the script to sign the server request with your CA."

exit 0
