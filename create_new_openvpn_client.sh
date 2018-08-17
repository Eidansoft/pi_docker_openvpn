#!/bin/bash

# This script will create a new client for the OpenVPN server.
# The following params are expected by the script:
#    1st The name for the client.

source common_functions.sh

CLIENT_NAME=$1
[ "$CLIENT_NAME" = "" ] && echo "[ERROR] The name for this Client is mandatory in order to be able to identify it. Please provide a name for the Client." && exit 1
[ ! -d $FILES_SVR_NAME_FOLDER ] && echo "[ERROR] The <$FILES_SVR_NAME_FOLDER> does not exist. You must execute the script to create all needded files for your server before create a valid client." && exit 1
[ ! -d $FILES_CA_NAME_FOLDER ] && echo "[ERROR] The <$FILES_CA_NAME_FOLDER> does not exist. You must execute the script to create all needded files for your CA before create a valid client." && exit 1


pushd $FILES_SVR_NAME_FOLDER
echo "set_var EASYRSA_REQ_CN \"VPN Client $CLIENT_NAME\"" >> /opt/EasyRSA/vars
easyrsa gen-req $CLIENT_NAME nopass
cp /opt/ca_conf.properties /opt/EasyRSA/vars
popd

pushd $FILES_CA_NAME_FOLDER
easyrsa import-req ../$FILES_SVR_NAME_FOLDER/pki/reqs/$CLIENT_NAME.req $CLIENT_NAME
easyrsa sign-req client $CLIENT_NAME
popd

create_folder_if_not_exist $FILES_CLIENTS_NAME_FOLDER/$CLIENT_NAME
chmod -R 700 $FILES_CLIENTS_NAME_FOLDER
CLIENT_FOLDER=$FILES_CLIENTS_NAME_FOLDER/$CLIENT_NAME

cp $FILES_SVR_NAME_FOLDER/pki/private/$CLIENT_NAME.key $CLIENT_FOLDER
cp $FILES_CA_NAME_FOLDER/pki/issued/$CLIENT_NAME.crt $CLIENT_FOLDER
cp $FILES_SVR_NAME_FOLDER/ta.key $CLIENT_FOLDER
cp $FILES_CA_NAME_FOLDER/pki/ca.crt $CLIENT_FOLDER
