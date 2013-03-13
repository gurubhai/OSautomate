#!/bin/bash

case $1 in
		"controller")
				./common_services.sh 2>&1 >>/tmp/install.log
				;;
				
		*)
				echo "Error. Give a node type controller, compute,etc"
				exit 1
				;;
				
esac
