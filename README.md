![logo-2](https://cloud.githubusercontent.com/assets/17197816/17171275/881cfd40-5422-11e6-9820-4eb7998923ff.png)

# Welcome to OpendayLight

A tutorial on setting up the whole virtual invironment for OpendayLight SDN controller.

# Environment

Category | Detail
--- | --- 
OS | Centos 7 or Ubuntu 14.04
SDN Controller | OpendayLight Beryllium-SR2
Virtual network | Mininet 2.2.1
Virtual switch | Open vSwitch 2.3.3
Network trafic generation | iperf or iperf3
Traffic monitoring | sFlow-RT

# Installation
## Install Git
### Ubuntu 14.04
```
sudo apt-get -y install git
```
### Centos 7
```
sudo yum -y install git
```
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
wget https://nexus.opendaylight.org/content/groups/public/org/opendaylight/integration/distribution-karaf/0.4.3-Beryllium-SR3/distribution-karaf-0.4.3-Beryllium-SR3.zip
```
#### Unzip the pre-built zip file (Place anywhere you want.) and run SDN Controller
```
unzip distribution-karaf-0.4.3-Beryllium-SR3.zip
cd distribution-karaf-0.4.3-Beryllium-SR3
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

##### Note: L2Switch Main (58-l2switchmain.xml)

• is-install-dropall-flow

```true``` means a drop-all flow will be installed on each switch, so the default action will be to drop a packet instead of sending it to the controller

```false``` means this flow will not be installed

#### Use web browser to login OpenDaylight SDN Controller
http://controller-ip:8181/index.html              
```
account:admin
password:admin
```
<img width="1280" alt="opendaylight" src="https://cloud.githubusercontent.com/assets/17197816/17204006/7a4c4eec-54d5-11e6-8ac9-ad54fe744f30.png">
if login fails,check firewall or reinstall components.
#### Check if Mininet,Ovs and SDN Controller is properly installed
```
root@user:~# sudo mn --topo single,3 --mac --switch ovsk,protocols=OpenFlow13 --controller remote
mininet>pingall
*** Ping: testing ping reachability
h1 -> h2 h3
h2 -> h1 h3
h3 -> h1 h2
*** Results: 0% dropped (6/6 received)
```
Go to http://controller-ip:8181/index.html and reload the topology,there should be a one-switch-three-host topology.
## Install Iperf3
```
sudo yum -y install epel-release
sudo yum -y install iperf3
```
## Install sFlow-RT
Note:sFlow-RT requires Java 1.7+
#### Download and start
```
wget http://www.inmon.com/products/sFlow-RT/sflow-rt.tar.gz
tar -xvzf sflow-rt.tar.gz
cd sflow-rt
./start.sh
```
#### Use web browser to check if sFlow is working
```
http://ip:8008
```
#### Set sFlow agent on openvswitch
```
sudo ovs-vsctl -- --id=@sflow create sflow agent=eth0 target=\"127.0.0.1:6343\" sampling=2 polling=20 -- -- set bridge YOUR-SWITCH-NAME sflow=@sflow
```
Success
```
root@user:~# ed495ce3-50b5-46b4-af1d-97510305ceca
```
faiure
```
root@user:~# ovs-vsctl: no row "YOUR-SWITCH-NAME" in table Bridge
```
#### Install applications
```
http://www.sflow-rt.com/download.php
```
Download all the applications you want , copy files to the sFlow-RT app directory and restart to install.

# Restful API
I use [Postman](https://www.getpostman.com) to send requests :) Download the Mac app or install the Chrome extension.
## Setup
#### Authorisation setting
1. Type -> select ```Basic Auth```
2. Username and Password -> both ```admin``` as default
3. Check ```Save helper data to request```
4. Click ```Update Request``` button

<img width="899" alt="2016-07-29 16 40 44" src="https://cloud.githubusercontent.com/assets/17197816/17242807/d11e1bde-55ab-11e6-9cad-221515a09a03.png">
#### Headers setting
1. There should be a key-value there ```Authorization Basic YWRtaW46YWRtaW4=``` produced by previous step.
2. Add a new key called ```Content-Type``` ,then determine what kind of format you prefer. e.g. ```application/json```
3. Add a new key called ```Accept``` ,then determine what kind of format you prefer. e.g. ```application/json```
4. Ready to go :))))

<img width="897" alt="2016-07-29 16 42 26" src="https://cloud.githubusercontent.com/assets/17197816/17242806/d11c9516-55ab-11e6-95af-472eb76a8db5.png">


## API List
#### Get specific node(switch) information
Method | URL
:---: | --- 
get | http://127.0.0.1:8181/restconf/operational/opendaylight-inventory:nodes/node/openflow:1
+ Note : ```openflow:1```is my demo node(switch) id, please revise to yours.

#### Get specific table statistics
Method | URL
:---: | --- 
get | http://127.0.0.1:8181/restconf/operational/opendaylight-inventory:nodes/node/openflow:1/flow-node-inventory:table/0/opendaylight-flow-table-statistics:flow-table-statistics

#### Get flow entries information in specific table
Method | URL
:---: | --- 
get | http://127.0.0.1:8181/restconf/operational/opendaylight-inventory:nodes/node/openflow:1/table/0

#### Get specific flow entry information
Method | URL
:---: | --- 
get | http://127.0.0.1:8181/restconf/operational/opendaylight-inventory:nodes/node/openflow:1/table/0/flow/1
+ Note : if your flow id look like this ```#UF$TABLE*0-1``` , use [URL encoding](http://www.url-encode-decode.com) for converting flow id to ```%23UF%24TABLE%2A0-1```

#### Add / Edit flow entry
Method | URL
:---: | --- 
put | http://127.0.0.1:8181/restconf/config/opendaylight-inventory:nodes/node/openflow:1/table/0/flow/1

<img width="897" alt="2016-08-03 11 38 47" src="https://cloud.githubusercontent.com/assets/17197816/17353087/015db32e-596f-11e6-965a-9d298de3cd77.png">

request body:
```
{
   "flow":[
      {
         "id":"1",
         "table_id":0,
         "match":{
            "ethernet-match":{
               "ethernet-type":{
                  "type":2048
               }
            },
            "ipv4-source":"8.8.8.8/24",
            "in-port":"openflow:1:3"
         },
         "instructions":{
            "instruction":[
               {
                  "order":0,
                  "apply-actions":{
                     "action":[
                        {
                           "order":0,
                           "output-action":{
                              "output-node-connector":"CONTROLLER",
                              "max-length":65535
                           }
                        },
                        {
                           "order":1,
                           "drop-action":{

                           }
                        }
                     ]
                  }
               }
            ]
         },
         "priority":20
      }
   ]
}
```
#### Delete flow entry
Method | URL
:---: | --- 
delete | http://127.0.0.1:8181/restconf/config/opendaylight-inventory:nodes/node/openflow:1/table/0/flow/1

# Conclusion
Please feel free to send me a pull request if you wanna contribute:)
