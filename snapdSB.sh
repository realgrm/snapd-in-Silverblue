#!/bin/env bash

SCRIPT_FOLDER=/opt/snapdSB/
bindnotok=0
symlinknok=0

#_____________________________________________________#

checkbindmount(){
	if [ -d '/home' ]
	then echo "bindmout of /home ok"
	else bindnok=1 && echo "bindmout of /home not ok"
	fi
}

bindmounthome(){

	if [ -L '/home' ]
	then echo "symlink /home will be replaced with a bind mount from /var/home"
	else echo "file /home will be replaced with a bind mount from /var/home"
	fi

	sudo rm -f /home 2&>${SCRIPT_FOLDER}/error.log
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
	if [ $(readlink "/snap") = "/var/mnt/snap" ]
	then echo 'snap symlink ok'
	else symlinknok=1 && echo 'snap symlink not ok'
	fi
}

symlinksnap(){
	echo "creating /var/mnt/snap symlink in /snap"
	sudo ln -sf '/var/mnt/snap' '/snap'
	checksymlink
}

#_____________________________________________________#

checkbindmount
checksymlink

passwdhome

if [ bindnotok=1 || symlinknok=1 ]
then sudo chattr -i /
	if [ bindnotok=1 ]; then bindmounthome; fi
	if [ symlinknok=1 ]; then symlinksnap; fi
	sudo chattr +i /
fi

