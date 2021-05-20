#!/bin/env bash

sudo cp -b snapdSB.sh /opt/bin

sudo cp -b snapdSB.service /etc/systemd/system/
sudo ln -s /etc/systemd/system/snapdSB.service /etc/systemd/system/remote-fs.target.wants/snapdSB.service
sudo systemctl start snapdSB.service

rpm-ostree install snapd
