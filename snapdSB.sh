#!/bin/env bash

SCRIPT_FOLDER=/opt/snapdSB/
bindnotok=0
symlinknok=0

#_____________________________________________________#

# check if bind mount in /home is already applied
checkbindmount(){
	if [ -d '/home' ] && [ ! -L '/home' ]
	then echo "bindmout of /home ok"
	else bindnotok=1 && echo "bindmout of /home not ok"
	fi
}

# replace symlink in /home with bind mount
bindmounthome(){

	if [ -L '/home' ]
	then echo "symlink /home will be replaced with bind mount from /var/home"
	else echo "bind mount will be created from /var/home to /home"
	fi

	rm -f /home | systemd-cat -t snapdSB.service -p info
	mkdir -p /home
	mount --bind /var/home /home
}

#_____________________________________________________#

# replace /var/home to /home in /etc/passwd
passwdhome(){
	if grep -Fq ':/var/home' /etc/passwd
	then
		cp /etc/passwd /etc/passwd.backup
		echo "backup of /etc/passwd created"
		sed -i 's|:/var/home|:/home|' /etc/passwd
		echo "/etc/passwd edited: /var/home replaced with /home"
	else
		echo "/etc/passwd ok"
	fi
}

#_____________________________________________________#

# check if symlink in /snap exists
checksymlink(){
	if [[ $(readlink "/snap") == "/var/lib/snapd/snap" ]]
	then echo 'snap symlink ok'
	else symlinknok=1 && echo 'snap symlink not ok'
	fi
}

# create symlink in /snap
symlinksnap(){
	echo "creating /var/lib/snapd/snap symlink in /snap"
	ln -sf '/var/lib/snapd/snap' '/snap' | systemd-cat -t snapdSB.service -p info
	checksymlink
}

#_____________________________________________________#

#if comment, steps bellow will not be checked and applied
#checkbindmount
checksymlink
passwdhome

# only unlock / if it's needed
if (( $bindnotok + $symlinknok ))
then
	chattr -i /
	if (( ${bindnotok} )); then bindmounthome; fi
	if (( ${symlinknok} )); then symlinksnap; fi
	chattr +i /
fi

