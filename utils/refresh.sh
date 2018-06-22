#!/bin/sh
. /etc/farmconfig


if [ "$OSTYPE" = "debian" ]; then
	apt-get update
elif [ "$OSTYPE" = "redhat" ]; then
	echo "refresh not required on RHEL"
elif [ "$OSTYPE" = "suse" ]; then
	aptitude update
elif [ "$OSTYPE" = "netbsd" ]; then
	pkgin update
elif [ "$OSTYPE" = "freebsd" ]; then
	pkg update
elif [ "$OSTYPE" = "qnap" ]; then
	ipkg update
else
	echo "repository refresh before upgrade not implemented on $OSTYPE system"
fi
