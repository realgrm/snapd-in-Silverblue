#!/bin/env bash

SCRIPT_FOLDER=/opt/snapdSB/
SCRIPT_FILE=snapdSB.sh

SERVICE_FOLDER=/etc/systemd/system/
SERVICE_NAME=snapdSB.service


sudo mkdir -p ${SCRIPT_FOLDER}
sudo cp -f * ${SCRIPT_FOLDER}
sudo chmod +x ${SCRIPT_FOLDER}${SCRIPT_FILE}

sudo cp -f ${SERVICE_NAME} ${SERVICE_FOLDER}
sudo ln -sf ${SERVICE_FOLDER}${SERVICE_NAME} \
	${SERVICE_FOLDER}remote-fs.target.wants/${SERVICE_NAME}

sudo mkdir -p /var/mnt/snap

${SCRIPT_FOLDER}${SCRIPT_FILE}

if ! [[ $(rpm -qa | grep snapd) ]];
then rpm-ostree install snapd; fi

