#!/bin/env bash

SCRIPT_FOLDER=/opt/snapdSB/
SCRIPT_FILE=snapdSB.sh

SERVICE_FOLDER=/etc/systemd/system/
SERVICE_NAME=snapdSB.service

if [[ $(rpm -qa | grep snapd) ]]; then rpm-ostree remove snapd; fi

sudo chattr -i /
	sudo rm -rf /snap
	if [ -L '/home' ]; then echo "/home is a symlink to /var/home"
	else
		sudo umount '/home' && if [ -d '/home' ] && [[ ! $(ls '/home') ]]
		then
			sudo rm -rf /home
			ln -sf /var/home /home
		else echo "something is wrong"; fi
	fi
sudo chattr +i /

sudo rm -rf ${SERVICE_FOLDER}${SERVICE_NAME}
sudo rm -rf ${SCRIPT_FOLDER}
