#!/bin/bash

TOKEN=pat_ERw9Xs21qZP8q4p1bSH52SpY
 
apt-get update && apt-get install -yq gnupg2 wget lsb-release
wget --http-user=signalwire --http-password=$TOKEN -O /usr/share/keyrings/signalwire-freeswitch-repo.gpg https://freeswitch.signalwire.com/repo/deb/debian-release/signalwire-freeswitch-repo.gpg
 
echo "machine freeswitch.signalwire.com login signalwire password $TOKEN" > /etc/apt/auth.conf
echo "deb [signed-by=/usr/share/keyrings/signalwire-freeswitch-repo.gpg] https://freeswitch.signalwire.com/repo/deb/debian-release/ `lsb_release -sc` main" > /etc/apt/sources.list.d/freeswitch.list
echo "deb-src [signed-by=/usr/share/keyrings/signalwire-freeswitch-repo.gpg] https://freeswitch.signalwire.com/repo/deb/debian-release/ `lsb_release -sc` main" >> /etc/apt/sources.list.d/freeswitch.list
 
apt-get update
  
# Install dependencies required for the build
apt-get build-dep freeswitch
  
# then let's get the source. Use the -b flag to get a specific branch
cd /usr/src/
git clone https://github.com/signalwire/freeswitch.git -bv1.10 freeswitch
cd freeswitch
  
# Because we're in a branch that will go through many rebases, it's
# better to set this one, or you'll get CONFLICTS when pulling (update).
git config pull.rebase true
  
# ... and do the build
./bootstrap.sh -j
./configure
make
make install