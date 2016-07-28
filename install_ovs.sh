#!/bin/sh -ev
# Reference: https://github.com/mininet/mininet/wiki/Installing-new-version-of-Open-vSwitch
# How to test: ovs-vsctl -V

# Check permission
test $(id -u) -ne 0 && echo "This script must be run as root" && exit 0

#Remove old version ovs
aptitude remove openvswitch-common openvswitch-datapath-dkms openvswitch-controller openvswitch-pki openvswitch-switch -y

#Install new version ovs
cd /tmp
wget http://openvswitch.org/releases/openvswitch-2.3.3.tar.gz
tar zxvf openvswitch-2.3.3.tar.gz
cd openvswitch-2.3.3
./configure --prefix=/usr --with-linux=/lib/modules/`uname -r`/build
make
make install
make modules_install
rmmod openvswitch
depmod -a

# Say goodbye to openvswitch-controller
/etc/init.d/openvswitch-controller stop
update-rc.d openvswitch-controller disable

#Start new version ovs
/etc/init.d/openvswitch-switch start

#Clean ovs
rm -rf /tmp/openvswitch-2.3.3*

