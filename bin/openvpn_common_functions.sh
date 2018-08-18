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
