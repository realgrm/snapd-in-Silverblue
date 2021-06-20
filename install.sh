#!/bin/env bash

SCRIPT_FOLDER=/opt/snapdSB/
SCRIPT_FILE=snapdSB.sh

SERVICE_FOLDER=/etc/systemd/system/
SERVICE_NAME=snapdSB.service

# choose if snap classic will be used
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

#install script
sudo mkdir -p ${SCRIPT_FOLDER}
sudo cp -f * ${SCRIPT_FOLDER}
sudo chmod +x ${SCRIPT_FOLDER}${SCRIPT_FILE}

# create service to run on start up to make sure changes are mantained
sudo cp -f ${SERVICE_NAME} ${SERVICE_FOLDER}
sudo ln -sf ${SERVICE_FOLDER}${SERVICE_NAME} \
	${SERVICE_FOLDER}remote-fs.target.wants/${SERVICE_NAME}

# make snap symlink target
sudo mkdir -p /var/lib/snapd/snap

# run script
${SCRIPT_FOLDER}${SCRIPT_FILE}

# install snapd if it's not already
if ! [[ $(rpm -qa | grep snapd) ]];
then rpm-ostree install snapd; fi

