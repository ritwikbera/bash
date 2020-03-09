#!/bin/bash


REMOTE_ALIAS="workstation" # set according to aliases in SSH config file
SYNC_FOLDER_PATH=$2
DIRECTION=$1
MODE="-a"

if [[ $3 == "dry" ]];
then
	MODE="-anv"
fi

if [[ $DIRECTION == "l2r" ]];
then
	rsync ${MODE} ~/${SYNC_FOLDER_PATH}/ ${REMOTE_ALIAS}:~/${SYNC_FOLDER_PATH}
else
	rsync ${MODE} ${REMOTE_ALIAS}:~/${SYNC_FOLDER_PATH}/ ~/${SYNC_FOLDER_PATH}
fi

