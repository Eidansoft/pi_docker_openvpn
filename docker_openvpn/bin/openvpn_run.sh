#!/bin/bash

# Load common functions
source openvpn_common_functions.sh

# The server name is mandatory
SVR_NAME=$1
[ "$SVR_NAME" = "" ] && echo "[ERROR] The server name is mandatory." && exit 1

# The folder with all certificates and keys must exist at the expected folder in order to be able to run the script
[ ! -d $FILES_OPENVPN_FOLDER ] && echo "[ERROR] The <$FILES_OPENVPN_FOLDER> does not exist. You must provide the folder with the certificates and keys to use with the OpenVPN service." && exit 1

# Copy all needed files for the openvpn server to work
cp /mnt/$FILES_OPENVPN_FOLDER/* /etc/openvpn/

# Configure the OpenVpn server to use the certificate created
sed -i.bak "s#^cert .*\.crt#cert /etc/openvpn/$SVR_NAME.crt#g" /etc/openvpn/server.conf
sed -i.bak "s#^key .*\.key#key /etc/openvpn/$SVR_NAME.key#g" /etc/openvpn/server.conf

# Configure the OpenVpn server to use the same protocol than the one configured for
# the client
protocol_line=$(cat $FILES_OPENVPN_FOLDER/openvpn_client.conf | grep "^proto")
sed -i.bak "s/^proto.\+$/$protocol_line/g" /etc/openvpn/server.conf

# Create the tun device if its not exists
mkdir -p /dev/net
if [ ! -c /dev/net/tun ]; then
    mknod /dev/net/tun c 10 200
fi

# Set the NAT rules to let the client surf the web when connected to the VPN. The IP 10.8.0.0 is the default IP used by openvpn server, that can be changed at the /etc/openvpn/server.conf if needed. And the eth0 interface is the default one created by the docker container.
iptables -t nat -C POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE

# Move into the openvpn folder and start the server
pushd /etc/openvpn/
openvpn --config /etc/openvpn/server.conf
