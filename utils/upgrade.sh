#!/bin/sh
. /etc/farmconfig


if [ -x /etc/local/hooks/pre-upgrade.sh ]; then
	/etc/local/hooks/pre-upgrade.sh
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

if [ -x /etc/local/hooks/post-upgrade.sh ]; then
	/etc/local/hooks/post-upgrade.sh
fi
