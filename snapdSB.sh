#!/bin/env bash

SCRIPT_FOLDER=/opt/snapdSB/
bindnotok=false
symlinknok=false

#_____________________________________________________#

checkbindmount(){
	if ! [ -L '/home' ]
	then echo "bindmout of /home ok"
	else bindnotok=true && echo "bindmout of /home not ok"
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
		echo "/etc/passwd ok"
	fi
}

#_____________________________________________________#

checksymlink(){
	if [ $(readlink "/snap") == "/var/lib/snapd/snap" ]
	then echo 'snap symlink ok'
	else symlinknok=true && echo 'snap symlink not ok'
	fi
}

symlinksnap(){
	echo "creating /var/lib/snapd/snap symlink in /snap"
	sudo ln -sf '/var/lib/snapd/snap' '/snap' | systemd-cat -t snapdSB.service -p info
	checksymlink
}

#_____________________________________________________#

# If its needed to run snaps in classic mode this will be necessary and will need to be uncommented
#checkbindmount
checksymlink

passwdhome

if [ $bindnotok == "true" ] || [ $symlinknok == "true" ]
then sudo chattr -i /
	if [ ${bindnotok} == "true" ]; then bindmounthome; fi
	if [ ${symlinknok} == "true" ]; then symlinksnap; fi
	sudo chattr +i /
fi
