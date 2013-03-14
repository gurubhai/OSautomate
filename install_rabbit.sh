#!/bin/bash

# Check if openstack configuration file is present, if yes then source it.
if [[ -f osconfig.conf ]]
then
	. osconfig.conf
else
	 echo "Configuration file not found. Please create osconfig.conf"
     exit 1
fi

	
install_rabbitmq()
{

	echo "********************************"
	echo "***** INSTALLING RABBITMQ ******"
	echo "********************************"
	sudo apt-get -y install rabbitmq-server
	
}

#Main
install_rabbitmq
