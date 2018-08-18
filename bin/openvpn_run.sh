#!/bin/bash

# The server name is mandatory
SVR_NAME=$1
[ "$SVR_NAME" = "" ] && echo "[ERROR] The server name is mandatory." && exit 1

# Copy all needed files for the openvpn server to work
cp /mnt/files_openvpn/* /etc/openvpn/

# Configure the OpenVpn server to use the certificate created
sed -i.bak "s/^cert .*\.crt/cert $SVR_NAME.crt/g" /etc/openvpn/server.conf
sed -i.bak "s/^key .*\.key/key $SVR_NAME.key/g" /etc/openvpn/server.conf

# Create the tun device if its not exists
mkdir -p /dev/net
if [ ! -c /dev/net/tun ]; then
    mknod /dev/net/tun c 10 200
fi

# Move into the openvpn folder and start the server
pushd /etc/openvpn/
openvpn --config /etc/openvpn/server.conf
