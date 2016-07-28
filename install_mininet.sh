#!/bin/bash
echo "download git"
sudo apt-get -y install git 

echo "get mininet source code"
cd ~/
git clone https://github.com/mininet/mininet.git

echo "install mininet"
#install everying
mininet/util/install.sh -a