#!/bin/env bash

# create symlink /snap
snapfolder(){
([ -L '/snap' ] && echo "snap symlink already exists") || \
(sudo ln -s '/var/mnt/snap' '/snap' && echo "symlink /snap created")
}

# bindmount /home
homefolder(){
([ -d '/home' ] && echo "home folder already exists") || \
([ -L '/home' ] && echo "the symlink /home will be replaced with a bind mount" && bindmounthome) ||
(echo "the file named /home will be replaced with a bind mount" && bindmounthome)
}

bindmounthome(){
  sudo rm -f /home 2&>1
  sudo mkdir -p /home
  sudo mount --bind /var/home /home
}

# replace /var/home to /home in /etc/passwd
passwdhome(){
  sudo cp /etc/passwd /etc/passwd.backup
  sudo sed -i 's|:/var/home|:/home|' /etc/passwd
  echo "/etc/passwd edited: /var/home replaced with /home"
}

snapfolder
homefolder
passwdhome
