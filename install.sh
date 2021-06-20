#!/bin/env bash

SCRIPT_FOLDER=/opt/snapdSB/
SCRIPT_FILE=snapdSB.sh

SERVICE_FOLDER=/etc/systemd/system/
SERVICE_NAME=snapdSB.service

read -n 1 -p "
Will you use snap classic?
This will replace the symlink /home with a bind mount
Undo this it's not implemented.
Only press y if you're really sure
" classic

case "$classic" in
	[yY][eE][sS]|[yY])
		sed -i 's|^#checkbindmount$|checkbindmount|' snapdSB.sh;;
	*)
		sed -i 's|^checkbindmount$|#checkbindmount|' snapdSB.sh;;
esac

sudo mkdir -p ${SCRIPT_FOLDER}
sudo cp -f * ${SCRIPT_FOLDER}
sudo chmod +x ${SCRIPT_FOLDER}${SCRIPT_FILE}

sudo cp -f ${SERVICE_NAME} ${SERVICE_FOLDER}
sudo ln -sf ${SERVICE_FOLDER}${SERVICE_NAME} \
	${SERVICE_FOLDER}remote-fs.target.wants/${SERVICE_NAME}

sudo mkdir -p /var/lib/snapd/snap

${SCRIPT_FOLDER}${SCRIPT_FILE}

if ! [[ $(rpm -qa | grep snapd) ]];
then rpm-ostree install snapd; fi

