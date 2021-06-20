#!/bin/env bash

SCRIPT_FOLDER=/opt/snapdSB/
SCRIPT_FILE=snapdSB.sh

SERVICE_FOLDER=/etc/systemd/system/
SERVICE_NAME=snapdSB.service
SERVICE_UNINSTALL=snapdSB_uninstall.service

sudo rm -rf ${SERVICE_FOLDER}${SERVICE_NAME}
sudo rm -rf ${SCRIPT_FOLDER}

# the undo of the bind mount is not working
sudo cp -f ${SERVICE_UNINSTALL} ${SERVICE_FOLDER}
sudo ln -sf ${SERVICE_FOLDER}${SERVICE_UNINSTALL} \
	${SERVICE_FOLDER}remote-fs.target.wants/${SERVICE_UNINSTALL}
