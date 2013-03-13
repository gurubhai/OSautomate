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
	
	sudo touch /etc/apt/sources.list.d/cloud.list
	echo "deb http://ubuntu-cloud.archive.canonical.com/ubuntu precise-updates/folsom main" | sudo tee -a /etc/apt/sources.list.d/cloud.list
	sudo apt-get -y install ubuntu-cloud-keyring
	sudo apt-get -y update && apt-get upgrade
	}

install_basic_packages(){
	
	sudo apt-get -y install vlan bridge-utils ntp python-mysqldb
	
	}
	
basic_tuning() {
	sudo sed -i 's/^#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
	sudo sysctl net.ipv4.ip_forward=1
}

# Main
configure_cloud_archive
install_basic_packages
basic_tuning

