![logo-2](https://cloud.githubusercontent.com/assets/17197816/17171275/881cfd40-5422-11e6-9820-4eb7998923ff.png)

## Welcome to OpendayLight

A tutorial on setting up the whole virtual invironment for OpendayLight SDN controller.

## Environment

Category | Detail
--- | --- | ---
OS | Centos 7 or Ubuntu 14.04
SDN Controller | OpendayLight Beryllium-SR2
Virtual network | Mininet 2.2.1
Virtual switch | Open vSwitch 2.3.3
Network trafic generation | iperf or iperf3
Traffic monitoring | sFlow-RT




## Installation

### Install OpendayLight SDN Controller
[Download](https://www.opendaylight.org/downloads) through web browser or use ```wget``` in terminal. (Note:following is currently the latest version.)
```
wget https://nexus.opendaylight.org/content/groups/public/org/opendaylight/integration/distribution-karaf/0.4.2-Beryllium-SR2/distribution-karaf-0.4.2-Beryllium-SR2.zip
```
Unzip the pre-built zip file (Place anywhere you want.) and run SDN Controller
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




### Install Git
 Centos 7
```
sudo yum -y install git
```
 Ubuntu 14.04
```
sudo apt-get install git
```
