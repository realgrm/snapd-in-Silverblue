#!/bin/env bash

SCRIPT_FILE=snapdSB.sh
SCRIPT_FOLDER=/opt/bin/
SERVICE_NAME=snapdSB.service
SERVICE_FOLDER=/etc/systemd/system/


sudo mkdir -p ${SCRIPT_FOLDER}
sudo cp -b ${SCRIPT_FILE} ${SCRIPT_FOLDER}
sudo chmod +x ${SCRIPT_FILE}

sudo cp -b ${SERVICE_NAME} ${SERVICE_FOLDER}
sudo ln -bs ${SERVICE_FOLDER}${SERVICE_NAME} ${SERVICE_FOLDER}remote-fs.target.wants/${SERVICE_NAME}

sudo systemctl daemon-reload
sudo systemctl start ${SERVICE_NAME}

rpm-ostree install snapd
