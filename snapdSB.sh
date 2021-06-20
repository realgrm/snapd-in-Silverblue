#!/bin/env bash

SCRIPT_FOLDER=/opt/snapdSB/
bindnotok=false
symlinknok=false

#_____________________________________________________#

checkbindmount(){
	if [ -d '/home' ]
	then echo "bindmout of /home ok"
	else bindnok=true && echo "bindmout of /home not ok"
	fi
}

bindmounthome(){

	if [ -L '/home' ]
	then echo "symlink /home will be replaced with a bind mount from /var/home"
	else echo "file /home will be replaced with a bind mount from /var/home"
	fi

	sudo rm -f /home | systemd-cat -t snapdSB.service -p info
	sudo mkdir -p /home
	sudo mount --bind /var/home /home
}

#_____________________________________________________#

# replace /var/home to /home in /etc/passwd
passwdhome(){
	if grep -Fq ':/var/home' /etc/passwd
	then
		sudo cp /etc/passwd /etc/passwd.backup
	echo "backup of /etc/passwd created"
		sudo sed -i 's|:/var/home|:/home|' /etc/passwd
		echo "/etc/passwd edited: /var/home replaced with /home"
		else
		echo "/etc/passwd already ok"
	fi
}

#_____________________________________________________#

checksymlink(){
	if [ $(readlink "/snap")=="/var/mnt/snap" ]
	then echo 'snap symlink ok'
	else symlinknok=true && echo 'snap symlink not ok'
	fi
}

symlinksnap(){
	echo "creating /var/mnt/snap symlink in /snap"
	sudo ln -sf '/var/mnt/snap' '/snap' | systemd-cat -t snapdSB.service -p info
	checksymlink
}

#_____________________________________________________#

# I couldn't find an app that didn't work when /var/home is not bind mounted to /home
# so the check and the bind mount is not executed and bindnotok is always false
#checkbindmount
checksymlink

passwdhome

if [ $bindnotok == "true" ] || [ $symlinknok == "true" ]
then sudo chattr -i /
	if [ ${bindnotok} ]; then bindmounthome; fi
	if [ ${symlinknok} ]; then symlinksnap; fi
	sudo chattr +i /
fi
