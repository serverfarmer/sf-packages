#!/bin/sh
. /etc/farmconfig


if [ -x /etc/local/hooks/pre-upgrade.sh ]; then
	/etc/local/hooks/pre-upgrade.sh --cleanup
fi

if [ "$OSTYPE" = "debian" ]; then
	apt-get autoremove && apt-get autoremove
elif [ "$OSTYPE" = "redhat" ]; then
	echo "cleanup not required on RHEL"
elif [ "$OSTYPE" = "suse" ]; then
	echo "cleanup not required on SuSE"
elif [ "$OSTYPE" = "netbsd" ]; then
	pkgin autoremove
	pkgin clean
elif [ "$OSTYPE" = "freebsd" ]; then
	pkg autoremove
else
	echo "cleanup not implemented on $OSTYPE system"
fi

if [ -x /etc/local/hooks/post-upgrade.sh ]; then
	/etc/local/hooks/post-upgrade.sh --cleanup
fi
