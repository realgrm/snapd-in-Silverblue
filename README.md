# snapd-in-Silverblue - Unmaintained

Due to lack of time and other atributions, this repo is unmaintained.

I found some interesting blog post about making it possible, but I didn't test:
https://nelsonaloysio.medium.com/installing-ubuntus-snap-on-fedora-silverblue-e82ca6fd6108

This is a test based on some comments found in the Fedora Silverblue repo and snapcraft documentation to make snap

Mostly based on 
- https://github.com/coreos/rpm-ostree/issues/337#issuecomment-620069234
- https://github.com/coreos/rpm-ostree/issues/337#issuecomment-620077671
- https://snapcraft.io/docs/home-outside-home


## What it tries to do
- create a symlink in /snap to /var/lib/snapd/snap
- create a bind mount in /home with /var/home. This is optional during install
- replace /var/home to /home in /etc/passwd
- create service to run on start up to make sure changes are mantained
- install snapd if it's not installed

## Current status: Unmaintained
~~Based on some tests on VM~~
- ~~install.sh: it's working~~
- ~~snapdSB.sh: it's woking~~
- ~~snapdSB.service: not working~~
- ~~uninstall.sh: working~~
- ~~snapdSB_uninstall.service: not working~~

~~Bind mount /home with /var/home is necessary to run snap in classic mode.  
But if applied, I don't know the full implications of it and 
I **couldn't find a way to undo it** in a script.~~

~~If you want to test, it's recommended do it in a VM~~

