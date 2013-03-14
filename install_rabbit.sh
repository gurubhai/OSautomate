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

	
install_rabbitmq()
{

	echo "********************************"
	echo "***** INSTALLING RABBITMQ ******"
	echo "********************************"
	sudo apt-get -y install rabbitmq-server
	
}

#Main
install_rabbitmq
