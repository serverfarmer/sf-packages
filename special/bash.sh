#!/bin/sh

if [ ! -x /bin/bash ]; then
	echo "attempting to install /bin/bash"

	# NetBSD
	if [ -x /usr/pkg/bin/pkgin ]; then
		pkgin update
		pkgin -y install bash
		ln -s /usr/pkg/bin/bash /bin/bash

	# FreeBSD
	# TODO: consider using pkg-static instead
	elif [ -x /usr/sbin/pkg ]; then
		pkg update
		pkg install -y bash
		ln -s /usr/local/bin/bash /bin/bash
	fi
fi
