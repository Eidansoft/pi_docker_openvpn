#!/bin/bash

# Generate the server authentication request and generate the server private key.
# This script expect the following params:
#    1st The server name

source common_functions.sh

SVR_NAME=$1
[ "$SVR_NAME" = "" ] && echo "[ERROR] The server name is mandatory." && exit 1

check_working_folder_not_exist $FILES_SVR_NAME_FOLDER

mkdir $FILES_SVR_NAME_FOLDER
pushd $FILES_SVR_NAME_FOLDER

easyrsa init-pki
echo "set_var EASYRSA_REQ_CN \"VPN Server $SVR_NAME\"" >> /opt/EasyRSA/vars
easyrsa gen-req $SVR_NAME nopass
cp /opt/ca_conf.properties /opt/EasyRSA/vars

easyrsa gen-dh
openvpn --genkey --secret ta.key

create_folder_if_not_exist ../$FILES_OPENVPN_FOLDER
cp ta.key ../$FILES_OPENVPN_FOLDER
cp pki/dh.pem ../$FILES_OPENVPN_FOLDER

popd


echo "######################################"
echo ""
echo "Summary:"
echo "You have created a new certificate for your server <$SVR_NAME>."
echo "The certificate request to be signed is at <$FILES_SVR_NAME_FOLDER/pki/reqs/$SVR_NAME.req>"
echo "The server private key is at <$FILES_SVR_NAME_FOLDER/pki/private/$SVR_NAME.key>"
echo "The Diffie-Hellman key is at <$FILES_OPENVPN_FOLDER/dh.pem>."
echo "The HMAC signature is at <$FILES_OPENVPN_FOLDER/ta.key>."
echo "Now you must run the script to sign the server request with your CA."
