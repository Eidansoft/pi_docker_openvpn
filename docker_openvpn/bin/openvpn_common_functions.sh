#!/bin/bash

FILES_CA_NAME_FOLDER=files_ca
FILES_SVR_NAME_FOLDER=files_svr
FILES_CLIENTS_NAME_FOLDER=files_clients
FILES_OPENVPN_FOLDER=files_openvpn

function check_working_folder_not_exist(){
    folder=$1
    [ -d $folder ] && echo "[ERROR] The folder <$folder> already exist, in order to create all the needed keys and certificates that folder must NOT exist. This is a security method to avoid overwrite your previously created keys and certificates." && exit 1
}

function create_folder_if_not_exist(){
    folder=$1
    [ ! -d $folder ] && mkdir -p $folder && echo "[INFO] Folder <$folder> created."
}

function is_openvpn_already_configured() {
    # Function to detect if the files openvpn_client.conf y ca_conf.properties are already configured. To detect it must exist the FILES_OPENVPN_FOLDER folder and contains the configuration files.
    [ ! -d $FILES_OPENVPN_FOLDER ] && echo "0" && return
    [ ! -f $FILES_OPENVPN_FOLDER/openvpn_client.conf ] && echo "0" && return
    [ ! -f $FILES_OPENVPN_FOLDER/ca_conf.properties ] && echo "0" && return
    echo "1"
}
