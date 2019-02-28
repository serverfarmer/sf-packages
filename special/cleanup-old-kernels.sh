#!/bin/sh
. /etc/farmconfig


# purge old, partially uninstalled kernels on Ubuntu
if [ "$OSTYPE" = "debian" ]; then
	dpkg -l linux-image* |grep ^rc |cut -d' ' -f3 |grep -v Status |xargs -r apt-get purge -y
fi
