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

## Create the Docker images
Once you have cloned the project, you need to build the docker image:

    sudo docker build . -t openvpnserver

## Create all needed stuff
In order to put the server up&running for the very first time, we must create some configuration files, keys and certificates.

To generate all this needed files you must start the docker container with a volume mounted at /mnt (with `-v YOUR_FOLDER:/mnt`), at this folder mounted the container will save for you all the files. For example, to run the container and save the generated files at current folder ($PWD) you must run:

    sudo docker run -it --name test --rm -v $PWD:/mnt openvpnserver /bin/bash

Once you have started the container you can call the scripts in order to execute the different tasks:

* Initialize the OpenVPN server certificates, keys and configurations.

    openvpn_server_init.sh <SERVER_NAME>

* Initialize the OpenVPN CA certificates and keys.

    openvpn_ca_init.sh <SERVER_NAME>

* Initialize the OpenVPN Client certificates, keys and configuration files.

    openvpn_client_init.sh <CLIENT_NAME>

At this point you have all needed files generated and saved at your folder. To be specific you will have four folders:

* files_ca - this folder contains all keys and certificates for your CA.
* files_svr - this folder contains all keys and certificates for your OpenVPN server.
* files_clients - this folder contains a folder for each client you have created. Inside those folders you will have the keys, certificates and configurations files for your clients.
* files_openvpn - this folder contains the configuration files for your OpenVPN server.

The only files you will need to copy to your RaspberryPi is the `files_openvpn` folder.
Once you have finished creating all the needed files you can close the running container just executing an `exit`.

## Start the container and run the OpenVPN service
At the RaspberryPi you must also have the project cloned, and you must have copied the `files_openvpn` folder. Once you are ready to go just run the following:

    sudo docker run -d --name openvpn --privileged -v PATH_OPENVPN_CONFIG_FILES:/mnt -p 11911:11911/udp --restart unless-stopped openvpnserver

That command configure and run your OpenVPN service, you can see the log with:

    sudo docker logs openvpn

## Stop the container with the OpenVPN service

    sudo docker rm -f openvpn
