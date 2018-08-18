#!/bin/bash

# Create the Certification Authority and generate their certificate and private key
# This script expect the following params:
#    1st The server name

# Load common functions
source openvpn_common_functions.sh

# The server name is mandatory
SVR_NAME=$1
[ "$SVR_NAME" = "" ] && echo "[ERROR] The server name is mandatory." && exit 1

# Avoid override previously existent certificates and keys
check_working_folder_not_exist $FILES_CA_NAME_FOLDER

# Create and enter into the folder to work with CA files
mkdir $FILES_CA_NAME_FOLDER
pushd $FILES_CA_NAME_FOLDER

# Create the initial PKI structure
easyrsa init-pki

# Generate the CA certificates
easyrsa build-ca nopass

# Import the server request to be signed by the CA
easyrsa import-req /mnt/$FILES_SVR_NAME_FOLDER/pki/reqs/$SVR_NAME.req $SVR_NAME

# Sign the server certificate
easyrsa sign-req server $SVR_NAME

# Save all openvpn service needed files into the recopilation folder
create_folder_if_not_exist ../$FILES_OPENVPN_FOLDER
cp pki/ca.crt ../$FILES_OPENVPN_FOLDER
cp pki/issued/$SVR_NAME.crt ../$FILES_OPENVPN_FOLDER

popd

# Put a summary at the user screen
echo "######################################"
echo ""
echo "Summary:"
echo "You have created a shiny new Certificate Authority (CA)."
echo "The CA private key is at <$FILES_CA_NAME_FOLDER/pki/private/ca.key>"
echo "CA certificate file for publishing is at: <$PWD/ca.crt>"
echo "The signed certificate for your server <$SVR_NAME> is at <$PWD/$SVR_NAME.crt>"

exit 0
