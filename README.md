# OpenVPN server running on a Docker container
The idea of this project is to have a OpenVPN server running on a container on a RaspberryPi

# Explanation

In order to get a OpenVpn server up and running into our RaspberryPi, first is important to understand some concepts.
First of all, the process to implement a VPN requires three parts:

 * The OpenVpn server application.
 * The Certification Authority (CA) to create the valid Certifications for the client and the server in order to recognise one each other.
 * The OpenVpn client to connect to the server.

In order to simplify the process I have created this container to do all needed tasks easy and quick.

# Manual of use
The first step is to generate all configuration files and keys, you can do it with the wizard 'openvpn_configure.sh'.
This should be run into your laptop, because the keys generation takes lot of time into the raspberry.

    docker run -it --name configuration --rm -v /path_to_folder/where_save/config:/mnt eidansoft/openvpn openvpn_configure.sh

# What will do the wizard for you?
It will ask you the values and configure them at following files.

* At the `openvpn_client.conf` file set the domain and the port you want to use for your server. The domain you must be the owner, or create one at www.no-ip.com and point it to your VPN Server.
The line to update is `remote myserver.ddns.net 1194`.

* At the `ca_conf.properties` file set the values to the ones better fit yourself, like your city, company name, mail, etc. Also here you can decide to change the size for your keys. I have set 4096 by default, for this reason the keys generation will take some time. If you prefer to use other valid value, feel free to change it.

And also it will call the scripts to generate all keys:

* Initialize the OpenVPN server certificates, keys and configurations.

    openvpn_server_init.sh <SERVER_NAME>

* Initialize the OpenVPN CA certificates and keys.

    openvpn_ca_init.sh <SERVER_NAME>

* Initialize the OpenVPN Client certificates, keys and configuration files.

    openvpn_client_init.sh <CLIENT_NAME>

Once the wizard finished you have all needed files generated and saved at your folder. To be specific you will have four folders:

* files_ca - this folder contains all keys and certificates for your CA.
* files_svr - this folder contains all keys and certificates for your OpenVPN server.
* files_clients - this folder contains a folder for each client you have created. Inside those folders you will have the keys, certificates and configurations files for your clients.
* files_openvpn - this folder contains the configuration files for your OpenVPN server.

The only files you will need to copy to your RaspberryPi is the `files_openvpn` folder.

## Start the container and run the OpenVPN service
    sudo docker run -d --name openvpn --privileged -v PATH_OPENVPN_CONFIG_FILES:/mnt -p 1194:1194/udp --restart unless-stopped eidansoft/openvpn

That command configure and run your OpenVPN service, you can see the log with:

    sudo docker logs openvpn

## Stop the container with the OpenVPN service

    sudo docker rm -f openvpn

# Known bugs
I have suffered some issues when the VPN server is running on a raspberry connected through WiFi. To fix it you must use TCPinstead UDP, currently not supported, I need to do some changes for that.
