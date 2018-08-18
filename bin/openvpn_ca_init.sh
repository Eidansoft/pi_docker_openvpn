#!/bin/bash

# Create the Certification Authority and generate their certificate and private key
# This script expect the following params:
#    1st The server name

source common_functions.sh

SVR_NAME=$1
[ "$SVR_NAME" = "" ] && echo "[ERROR] The server name is mandatory." && exit 1

check_working_folder_not_exist $FILES_CA_NAME_FOLDER

mkdir $FILES_CA_NAME_FOLDER
pushd $FILES_CA_NAME_FOLDER

easyrsa init-pki
easyrsa build-ca nopass

easyrsa import-req /mnt/$FILES_SVR_NAME_FOLDER/pki/reqs/$SVR_NAME.req $SVR_NAME
easyrsa sign-req server $SVR_NAME

create_folder_if_not_exist ../$FILES_OPENVPN_FOLDER
cp pki/ca.crt ../$FILES_OPENVPN_FOLDER
cp pki/issued/$SVR_NAME.crt ../$FILES_OPENVPN_FOLDER

popd

echo "######################################"
echo ""
echo "Summary:"
echo "You have created a shiny new Certificate Authority (CA)."
echo "The CA private key is at <$FILES_CA_NAME_FOLDER/pki/private/ca.key>"
echo "CA certificate file for publishing is at: <$PWD/ca.crt>"
echo "The signed certificate for your server <$SVR_NAME> is at <$PWD/$SVR_NAME.crt>"
