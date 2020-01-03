#!/bin/bash

# Generate the configuration if not already done.

# Load common functions
source openvpn_common_functions.sh

function configure_domain_and_port() {
    read -p "What will be your openVPN domain name? (example: my-vpn.ddns.net) "
    server_name=$REPLY
    read -p "On what port do you wanna OpenVPN listen you? (example: 1194) "
    port=$REPLY
    cat /tmp/openvpn_client.conf | sed "s/remote myserver.ddns.net 1194/remote $server_name $port/g" > $FILES_OPENVPN_FOLDER/openvpn_client.conf
    read -p "Do you wanna use TCP or UDP? (example: udp) "
    protocol=$REPLY
    cat $FILES_OPENVPN_FOLDER/openvpn_client.conf | sed "s/proto udp/proto $protocol/g" > $FILES_OPENVPN_FOLDER/openvpn_client.conf
}

function configure_ca() {
    ca_conf_file="$FILES_OPENVPN_FOLDER/ca_conf.properties"
    read -p "What's your country code? (examples: ES, UK, US, ...) "
    echo "set_var EASYRSA_REQ_COUNTRY    \"$REPLY\"" > ca_conf_file
    read -p "What's your province? (example: Andalucia) "
    echo "set_var EASYRSA_REQ_PROVINCE   \"$REPLY\"" >> ca_conf_file
    read -p "What's your city? (example: Sevilla) "
    echo "set_var EASYRSA_REQ_CITY       \"$REPLY\"" >> ca_conf_file
    read -p "What's your company name? (example: Darma Initiative Inc.) "
    echo "set_var EASYRSA_REQ_ORG        \"$REPLY\"" >> ca_conf_file
    read -p "What's your e-mail? (example: ceo@darma.com) "
    echo "set_var EASYRSA_REQ_EMAIL      \"$REPLY\"" >> ca_conf_file
    echo "set_var EASYRSA_REQ_OU         \"Personal\"" >> ca_conf_file
    read -p "What key size do you wanna use [2048 or 4096]? (I strongly recomend you 4096) "
    echo "set_var EASYRSA_KEY_SIZE        $REPLY" >> ca_conf_file
}

function configure_openvpn() {
    echo "[INFO] We are gonna configure the server files and keys ..."
    openvpn_server_init.sh svr
    echo "[INFO] We are gonna configure the CA files and keys ..."
    openvpn_ca_init.sh svr
    echo "[INFO] We are gonna configure the client ..."
    read -p "What client do you wanna configure? (example: myiphone, homepc, workpc, ...) "
    openvpn_client_init.sh $REPLY
}

is_configured=$(is_openvpn_already_configured)
if [ "$is_configured" == "0" ]; then
    echo "[INFO] OpenVPN not configured."
    read -p "Do you wanna configure it now? (y/n) "
    if [ "$REPLY" == "y" -o "$REPLY" == "Y" ]; then
        create_folder_if_not_exist $FILES_OPENVPN_FOLDER
        configure_domain_and_port
        configure_ca
        configure_openvpn
    fi
else
    configure_openvpn
fi
