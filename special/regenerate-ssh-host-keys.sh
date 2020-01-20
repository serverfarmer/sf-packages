#!/bin/sh

if [ "$REGENERATE_HOST_KEYS" != "" ]; then

	if [ -x /usr/sbin/dpkg-reconfigure ]; then
		rm -f /etc/ssh/ssh_host_*
		dpkg-reconfigure openssh-server

	elif [ -x /usr/sbin/sshd-keygen ]; then
		rm -f /etc/ssh/ssh_host_*
		/usr/sbin/sshd-keygen   # RHEL 7.x

	else
		echo "regenerating host ssh keys is not supported on this system"
	fi
fi
