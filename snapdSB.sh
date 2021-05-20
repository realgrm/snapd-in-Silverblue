#!/bin/env bash

# create symlink /snap
snapfolder(){
[ -L '/snap' ] && echo "snap symlink already exists" || \
sudo ln -s '/var/mnt/snap' '/snap' && echo "symlink /snap created"
}

# bindmount /home
homefolder(){
[ -D '/home' ] && echo "home folder already exists" || \
[ -L '/home' ] && echo "the symlink /home will be replaced with a bind mount" && bindmounthome ||
echo "the file named /home will be replaced with a bind mount" && bindmounthome
}

bindmounthome(){
  sudo rm -f /home 2&>1
  sudo mkdir -p /home
  sudo mount --bind /var/home /home
}

# replace /var/home to /home in /etc/passwd
passwdhome(){
  sudo cp /etc/passwd /etc/passwd.backup
  sudo awk -vold=$"/var/home" -vnew=$"/home" -F: ' BEGIN {OFS = ":"} \
    {sub(old,new,$6);print}' /etc/passwd > /etc/passwd
}

snapfolder
homefolder
passwdhome
