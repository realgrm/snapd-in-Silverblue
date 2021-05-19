sudo cp snapdSB-mount-snap.service /etc/systemd/system/
sudo ln -s /etc/systemd/system/snapdSB-mount-snap.service /etc/systemd/system/remote-fs.target.wants/snapdSB-mount-snap.service
sudo systemctl start snapdSB-mount-snap.service

sudo cp snapdSB-bindmount-home.service /etc/systemd/system/
sudo ln -s /etc/systemd/system/snapdSB-bindmount-home.service /etc/systemd/system/remote-fs.target.wants/snapdSB-bindmount-home.service
sudo systemctl start snapdSB-bindmount-home.service

sudo cp snapdSB-passwd.service /etc/systemd/system/
sudo ln -s /etc/systemd/system/snapdSB-passwd.service /etc/systemd/system/remote-fs.target.wants/snapdSB-passwd.service
sudo systemctl start snapdSB-passwd.service

rpm-ostree install snapd

#TODO: put this in snapdSB-bindmount-home.service
[ -D '/home' ] && echo "home folder already exists" || \
[ -L '/home' ] && echo "the symlink /home will be replaced with a bind mount" && bindmounthome ||
echo "the file named /home will be replaced with a bind mount" && bindmounthome

bindmounthome () {
  sudo rm -f /home
  sudo mkdir -p /home
  sudo mount --bind /var/home /home
}

#TODO: put this in snapdSB-passwd.service
sudo cp /etc/passwd /etc/passwd.backup

sudo awk -vold=$"/var/home" -vnew=$"/home" -F: ' BEGIN {OFS = ":"} \
  {sub(old,new,$6);print}' /etc/passwd > /etc/passwd




