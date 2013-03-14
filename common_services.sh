#!/bin/bash

# Check if openstack configuration file is present, if yes then source it.
if [[ -f osconfig.conf ]]
then
	. osconfig.conf
else
	 echo "Configuration file not found. Please create osconfig.conf"
         exit 1
fi

configure_cloud_archive(){
	
	sudo rm -f /etc/apt/sources.list.d/cloud.list
	sudo touch /etc/apt/sources.list.d/cloud.list
	echo "deb http://ubuntu-cloud.archive.canonical.com/ubuntu precise-updates/folsom main" | sudo tee -a /etc/apt/sources.list.d/cloud.list
	sudo apt-get -y install ubuntu-cloud-keyring
	echo "Now updating and upgrading...Please have a cup coffee"
	sudo apt-get -y update 
	sudo apt-get -y upgrade
	}

install_basic_packages(){
	
	echo "Now installing vlan bridge-utils ntp python-mysqldb"
	sudo apt-get -y install vlan bridge-utils ntp python-mysqldb
	
	}
	
enable_ip_forwarding() {
	sudo sed -i /'s/^#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g/' /etc/sysctl.conf
	sudo sysctl net.ipv4.ip_forward=1
	}
	
configure_ntp(){
	echo "***************************"
	echo "***** CONFIGURING NTP *****"
	echo "***************************"
	sudo sed -i /'s/server ntp.ubuntu.com/server ntp.ubuntu.com\nserver 127.127.1.0\nfudge 127.127.1.0 stratum 10/g/' /etc/ntp.conf
    sudo service ntp restart
}

# Main
configure_cloud_archive
install_basic_packages
enable_ip_forwarding
configure_ntp

