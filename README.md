# pi_docker_openvpn
OpenVpn server to run into a docker container with a RaspberryPi

# Explanation

In order to get a OpenVpn server up and running into our RaspberryPi, first is important to understand some concepts.
First of all you will need three parts:

 * The OpenVpn server application.
 * The Certification Authority to create the valid Certifications for the client to be used to connect to the OpenVpn server.
 * The OpenVpn client to connect to the server.

# Installation

Grab a RaspberryPi and intall an Raspbian SO.
Once it's up and running we can start:

## Activate the SSH server

Running the command:

    sudo raspi-config

Select <interfaces> and activate the SSH server, after this change you need to reboot the machine.

## Change the default password for the user 'pi'

    passwd

## Set a fixed ip for the machine

This can be easely done at the router.

## Update and Upgrade the repositories and dependencies:

Execute:

    sudo apt-get update
    sudo apt-get upgrade

## Install useful utilities

Some of the utilities that I are acostume to use are:

    sudo apt-get install tmux git

## Install Docker:

    sudo curl -sSL https://get.docker.com/ | sh

## Clone this project at the machine

    git clone https://github.com/Eidansoft/pi_docker_openvpn.git

## Create the Docker images

    sudo docker build . -t openvpnserver

## Start the container and run the OpenVPN service

    sudo docker run -d --name openvpn --privileged -v $PWD:/mnt -p 11911:11911/udp --restart unless-stopped openvpnserver

## Stop the container with the OpenVPN service

    sudo docker rm -f openvpn

# Manual tasks
You can start the docker container running just a /bin/bash prompt and work manually with all scripts. To start the container:

   sudo docker run -it --name test --rm -v $PWD:/mnt openvpnserver /bin/bash

Once you have started the container you can call any of the scripts in order to execute the different tasks:

* Initialize the OpenVPN server certificates, keys and configurations.

    openvpn_server_init.sh <SERVER_NAME>

* Initialize the OpenVPN CA certificates and keys.

    openvpn_ca_init.sh <SERVER_NAME>

* Initialize the OpenVPN Client certificates, keys and configuration files.

    openvpn_client_init.sh <CLIENT_NAME>

* Start the OpenVpn service (In order to be able to run the service the container must have been started with the privileged param and the exposed port to use)

    openvpn_run.sh <SERVER_NAME>