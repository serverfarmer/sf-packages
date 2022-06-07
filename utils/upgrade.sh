#!/bin/sh
. /etc/farmconfig


if [ -x ~/.serverfarmer/hooks/pre-upgrade.sh ]; then
	~/.serverfarmer/hooks/pre-upgrade.sh
fi

if [ -x /opt/farm/ext/service-restarter/utils/docker-save.sh ]; then
	/opt/farm/ext/service-restarter/utils/docker-save.sh
fi

if [ -s /etc/local/.config/upgrade.disable ]; then
	echo "upgrade disabled by upgrade.disable file"
elif [ "$OSTYPE" = "debian" ]; then
	apt-get upgrade
elif [ "$OSTYPE" = "redhat" ] || [ "$OSTYPE" = "amazon" ]; then
	yum update
elif [ "$OSTYPE" = "suse" ]; then
	aptitude upgrade
elif [ "$OSTYPE" = "netbsd" ]; then
	pkgin upgrade
elif [ "$OSTYPE" = "freebsd" ]; then
	pkg-static upgrade
elif [ "$OSTYPE" = "qnap" ]; then
	ipkg upgrade
else
	echo "upgrade not implemented on $OSTYPE system"
fi

if [ -x /opt/farm/ext/service-restarter/utils/docker-restart.sh ] && [ ! -s /etc/local/.config/upgrade.disable ]; then
	/opt/farm/ext/service-restarter/utils/docker-restart.sh
fi

if [ -x ~/.serverfarmer/hooks/post-upgrade.sh ]; then
	~/.serverfarmer/hooks/post-upgrade.sh
fi
