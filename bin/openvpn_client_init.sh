#!/bin/bash

# This script will create a new client for the OpenVPN server.
# The following params are expected by the script:
#    1st The name for the client.

# Load common functions
source openvpn_common_functions.sh

# The client name is mandatory
CLIENT_NAME=$1
[ "$CLIENT_NAME" = "" ] && echo "[ERROR] The name for this Client is mandatory in order to be able to identify it. Please provide a name for the Client." && exit 1

# The server folder and the CA folder must exist in order to be able to run this script
[ ! -d $FILES_SVR_NAME_FOLDER ] && echo "[ERROR] The <$FILES_SVR_NAME_FOLDER> does not exist. You must execute the script to create all needded files for your server before create a valid client." && exit 1
[ ! -d $FILES_CA_NAME_FOLDER ] && echo "[ERROR] The <$FILES_CA_NAME_FOLDER> does not exist. You must execute the script to create all needded files for your CA before create a valid client." && exit 1

# To generate the client certificates I'm gonna work at the server folder (for that reason it must previously exist), so now I change to that folder
pushd $FILES_SVR_NAME_FOLDER

# Generate the client certificate request
easyrsa --batch --req-cn="VPN Client $CLIENT_NAME" gen-req $CLIENT_NAME nopass

popd

# Change to the CA folder in order to be able to sign the client certificate
pushd $FILES_CA_NAME_FOLDER

# Import the client request to be signed
easyrsa import-req ../$FILES_SVR_NAME_FOLDER/pki/reqs/$CLIENT_NAME.req $CLIENT_NAME

# Sign the client certificate
easyrsa --batch sign-req client $CLIENT_NAME

popd

# Save all openvpn service needed files into the recopilation folder
create_folder_if_not_exist $FILES_CLIENTS_NAME_FOLDER/$CLIENT_NAME
chmod -R 700 $FILES_CLIENTS_NAME_FOLDER
CLIENT_FOLDER=$FILES_CLIENTS_NAME_FOLDER/$CLIENT_NAME

cp $FILES_SVR_NAME_FOLDER/pki/private/$CLIENT_NAME.key $CLIENT_FOLDER
cp $FILES_CA_NAME_FOLDER/pki/issued/$CLIENT_NAME.crt $CLIENT_FOLDER
cp $FILES_SVR_NAME_FOLDER/ta.key $CLIENT_FOLDER
cp $FILES_CA_NAME_FOLDER/pki/ca.crt $CLIENT_FOLDER

# Generate the *.ovpn file for the client
cat /tmp/openvpn_client.conf \
    <(echo -e '<ca>') \
    $CLIENT_FOLDER/ca.crt \
    <(echo -e '</ca>\n<cert>') \
    $CLIENT_FOLDER/$CLIENT_NAME.crt \
    <(echo -e '</cert>\n<key>') \
    $CLIENT_FOLDER/$CLIENT_NAME.key \
    <(echo -e '</key>\n<tls-auth>') \
    $CLIENT_FOLDER/ta.key \
    <(echo -e '</tls-auth>') \
    > $CLIENT_FOLDER/$CLIENT_NAME.ovpn

exit 0
