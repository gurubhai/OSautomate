#!/bin/bash

# Check if openstack configuration file is present, if yes then source it.
if [[ -f osconfig.conf ]]
then
	. osconfig.conf
else
	 echo "Configuration file not found. Please create osconfig.conf"
     exit 1
fi



install_mysql() 
{
	echo "mysql-server-5.5 mysql-server/root_password password $MYSQL_ROOT_PASS" | sudo debconf-set-selections
	echo "mysql-server-5.5 mysql-server/root_password_again password $MYSQL_ROOT_PASS" | sudo debconf-set-selections
	echo "mysql-server-5.5 mysql-server/root_password seen true" | sudo debconf-set-selections
	echo "mysql-server-5.5 mysql-server/root_password_again seen true" | sudo debconf-set-selections

	sudo apt-get -y install mysql-server python-mysqldb
}

configure_mysql() 
{
	sudo sed -i "s/bind-address.*/bind-address = $MYSQL_SERVER/" /etc/mysql/my.cnf
	sudo service mysql restart
}

drop_db() 
{
	# Drop database
	for d in nova glance cinder keystone quantum
	do
	mysql -uroot -p$MYSQL_ROOT_PASS -e "drop database if exists $d;"
	done
}


create_db()
{
	#Create Databases.
		
	#NOVA 
	mysql -uroot -p$MYSQL_ROOT_PASS -e "CREATE DATABASE nova;"
	mysql -uroot -p$MYSQL_ROOT_PASS -e "GRANT ALL PRIVILEGES ON nova.* TO \"$NOVADBADMIN\"@\"%\" IDENTIFIED BY \"$NOVADBPASS\";"
	
	#GLANCE
	mysql -uroot -p$MYSQL_ROOT_PASS -e "CREATE DATABASE glance;"
	mysql -uroot -p$MYSQL_ROOT_PASS -e "GRANT ALL PRIVILEGES ON glance.* TO \"$GLANCEDBADMIN\"@\"%\" IDENTIFIED BY \"$GLANCEDBPASS\";"
	
	#KEYSTONE
	mysql -uroot -p$MYSQL_ROOT_PASS -e "CREATE DATABASE keystone;"
	mysql -uroot -p$MYSQL_ROOT_PASS -e "GRANT ALL PRIVILEGES ON keystone.* TO \"$KEYSTONEDBADMIN\"@\"%\" IDENTIFIED BY \"$KEYSTONEDBPASS\";"
		
	#QUANTUM
	mysql -uroot -p$MYSQL_ROOT_PASS -e "CREATE DATABASE quantum;"
	mysql -uroot -p$MYSQL_ROOT_PASS -e "GRANT ALL PRIVILEGES ON quantum.* TO \"$QUANTUMDBADMIN\"@\"%\" IDENTIFIED BY \"$QUANTUMDBPASS\";"
		
	#HORIZON
	mysql -uroot -p$MYSQL_ROOT_PASS -e "CREATE DATABASE cinder;"
	mysql -uroot -p$MYSQL_ROOT_PASS -e "GRANT ALL PRIVILEGES ON cinder.* TO TO \"$CINDERDBADMIN\"@\"%\" IDENTIFIED BY \"$CINDERDBPASS\";"
	
	
}


# Main
install_mysql
configure_mysql
drop_db
create_db
