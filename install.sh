#!/bin/env bash

SCRIPT_FOLDER=/usr/local/bin/
SCRIPT_FILE=home_snapdSB.sh

SERVICE_FOLDER=/etc/systemd/system/
SERVICE_NAME=snapdSB.service


sudo mkdir -p ${SCRIPT_FOLDER}
sudo cp -f ${SCRIPT_FILE} ${SCRIPT_FOLDER}
sudo chmod +x ${SCRIPT_FOLDER}${SCRIPT_FILE}

sudo cp -f ${SERVICE_NAME} ${SERVICE_FOLDER}
sudo ln -sf ${SERVICE_FOLDER}${SERVICE_NAME} ${SERVICE_FOLDER}remote-fs.target.wants/${SERVICE_NAME}

${SCRIPT_FOLDER}${SCRIPT_FILE}

sudo systemctl daemon-reload
sudo systemctl start ${SERVICE_NAME}

# rpm-ostree install snapd
