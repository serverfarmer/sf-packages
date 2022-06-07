#!/bin/sh
. /etc/farmconfig


if [ -x ~/.serverfarmer/hooks/pre-upgrade.sh ]; then
	~/.serverfarmer/hooks/pre-upgrade.sh --cleanup
fi

if [ -s /etc/local/.config/upgrade.disable ] && [ "$OSTYPE" = "debian" ]; then
	echo "cleanup disabled by upgrade.disable file"
elif [ "$OSTYPE" = "debian" ]; then
	apt-get autoremove && apt-get autoremove && apt-get clean
elif [ "$OSTYPE" = "amazon" ]; then
	echo "cleanup not required on Amazon Linux"
elif [ "$OSTYPE" = "redhat" ]; then
	echo "cleanup not required on RHEL"
elif [ "$OSTYPE" = "suse" ]; then
	echo "cleanup not required on SuSE"
elif [ "$OSTYPE" = "netbsd" ]; then
	pkgin autoremove
	pkgin clean
elif [ "$OSTYPE" = "freebsd" ]; then
	pkg-static autoremove
else
	echo "cleanup not implemented on $OSTYPE system"
fi

if [ -x ~/.serverfarmer/hooks/post-upgrade.sh ]; then
	~/.serverfarmer/hooks/post-upgrade.sh --cleanup
fi
