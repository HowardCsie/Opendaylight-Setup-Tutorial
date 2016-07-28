![logo-2](https://cloud.githubusercontent.com/assets/17197816/17171275/881cfd40-5422-11e6-9820-4eb7998923ff.png)

# Welcome to OpendayLight

A tutorial on setting up the whole virtual invironment for OpendayLight SDN controller.

# Environment

Category | Detail
--- | --- | ---
OS | Centos 7 or Ubuntu 14.04
SDN Controller | OpendayLight Beryllium-SR2
Virtual network | Mininet 2.2.1
Virtual switch | Open vSwitch 2.3.3
Network trafic generation | iperf or iperf3
Traffic monitoring | sFlow-RT

# Installation

## Install Mininet
### Ubuntu 14.04
#### Run the sript and all things finish automatically:)))
 ```
 ./install_mininet.sh
 ```
### Centos 7
#### Download
```
git clone https://github.com/mininet/mininet.git
```
#### Update installer mininet/util/install.sh
(1) ADD the following before the line ‘test -e /etc/fedora-release && DIST=”Fedora”‘. Somewhere around line 47.  May differ.
```
test -e /etc/centos-release && DIST="CentOS"
if [ "$DIST" = "CentOS" ]; then
    install='sudo yum -y install'
    remove='sudo yum -y erase'
    pkginst='sudo rpm -ivh'
    # Prereqs for this script
    if ! which lsb_release &> /dev/null; then
        $install redhat-lsb-core
    fi
fi
```
(2) EDIT
 ```
if ! echo $DIST | egrep 'Ubuntu|Debian|Fedora'; then
    echo "Install.sh currently only supports Ubuntu, Debian and Fedora."
    exit 1
fi
 ```
to
 ```
if ! echo $DIST | egrep 'Ubuntu|Debian|Fedora|CentOS'; then
    echo "Install.sh currently only supports Ubuntu, Debian and Fedora."
    exit 1
fi
 ```
#### Install Mininet and OpenFlow reference
```
mininet/util/install.sh -nf
```
## Install Open vSwitch
### Ubuntu 14.04
#### Run the sript and all things finish automatically:)))
 ```
 ./install_ovs.sh
 ```
### Centos 7
#### Download
```
yum -y install wget gcc make python-devel openssl-devel kernel-devel graphviz kernel-debug-devel autoconf automake rpm-build redhat-rpm-config libtool
```
#### Prepare
```
adduser ovs
su - ovs
wget http://openvswitch.org/releases/openvswitch-2.3.3.tar.gz
cp openvswitch-2.3.3.tar.gz ~/rpmbuild/SOURCES/
tar xfz openvswitch-2.3.3.tar.gz
sed 's/openvswitch-kmod, //g' openvswitch-2.3.3/rhel/openvswitch.spec > openvswitch-2.3.3/rhel/openvswitch_no_kmod.spec
rpmbuild -bb --nocheck openvswitch-2.3.3/rhel/openvswitch_no_kmod.spec
exit
```
#### Create the /etc/openvswitch configuration directory
```
mkdir /etc/openvswitch
```
#### Install the rpm package
```
yum localinstall /home/ovs/rpmbuild/RPMS/x86_64/openvswitch-2.3.3-1.x86_64.rpm
```
#### Start the openvswitch service
```
systemctl start openvswitch.service
```
#### Start the openvswitch service at boot time
```
chkconfig openvswitch on
```
#### Check working
```
root@user:~# sudo ovs-vsctl show
5ad5c67c-163b-41a3-9d60-9708efe79cbd
ovs_version: “2.3.3”
root@user:~# sudo mn --test pingall
*** Creating network
*** Adding controller
*** Adding hosts:
      .
      .
      .
*** Results: 0% dropped (2/2 received)
*** Stopping 1 controllers
c0
*** Stopping 1 switches
s1 ..
*** Stopping 2 hosts
h1 h2
*** Done
completed in 5.125 seconds
```

## Install OpendayLight SDN Controller
#### [Download](https://www.opendaylight.org/downloads) through web browser or use ```wget``` in terminal. (Note:following is currently the latest version.)
```
wget https://nexus.opendaylight.org/content/groups/public/org/opendaylight/integration/distribution-karaf/0.4.2-Beryllium-SR2/distribution-karaf-0.4.2-Beryllium-SR2.zip
```
#### Unzip the pre-built zip file (Place anywhere you want.) and run SDN Controller
```
unzip distribution-karaf-0.4.2-Beryllium-SR2.zip
cd distribution-karaf-0.4.2-Beryllium-SR2
./bin/karaf
```
Use ```version``` to check the version.
```
opendaylight-user@root>version
3.0.3
```
#### Install controller components
Reference:https://www.opendaylight.org/software/downloads/beryllium-sr2
```
opendaylight-user@root>feature:install odl-mdsal-clustering
opendaylight-user@root>feature:install odl-restconf
opendaylight-user@root>feature:install odl-l2switch-switch
opendaylight-user@root>feature:install odl-openflowplugin-all
opendaylight-user@root>feature:install odl-dlux-all
opendaylight-user@root>feature:install odl-mdsal-all
```
Advisement: Install odl-mdsal-clustering first then install other components one by one

Check all the components ```feature:list```

Check installed components ```feature:list -i```

## Install Git
### Ubuntu 14.04
```
sudo apt-get -y install git
```
### Centos 7
```
sudo yum -y install git
```

