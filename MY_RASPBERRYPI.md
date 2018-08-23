# A couple notes about my configurations
Just a couple notes about the base configuration that I use by default into my RaspberryPi

* Install Raspbian SO (https://www.raspberrypi.org/documentation/installation/installing-images/).

* Once it's up and running we can start to configure it:

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

Some of the utilities that I are acostume to:

    sudo apt-get install tmux git ntp

## Install Docker:

    sudo curl -sSL https://get.docker.com/ | sh
