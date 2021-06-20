# snapd-in-Silverblue

This is a test based on some comments found in the Fedora Silverblue repo and snapcraft documentation

Mostly based on 
- https://github.com/coreos/rpm-ostree/issues/337#issuecomment-620069234
- https://github.com/coreos/rpm-ostree/issues/337#issuecomment-620077671
- https://snapcraft.io/docs/home-outside-home

## Current results:
Based on some tests on VM, it's working, but if the bind mount in /home is applied I could not find a way to undo in a script.  
If you want to test, it's recommended do it in a VM
