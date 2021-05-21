#!/bin/env bash

# bindmount /home
homefolder(){
([ -L '/home' ] && echo "the symlink /home will be replaced with a bind mount" && bindmounthome) || \
([ -d '/home' ] && echo "/home already ok") || \
(echo "the file named /home will be replaced with a bind mount" && bindmounthome)
}

bindmounthome(){
  sudo rm -f /home 2&>1
  sudo mkdir -p /home
  sudo mount --bind /var/home /home
}

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

homefolder
passwdhome
