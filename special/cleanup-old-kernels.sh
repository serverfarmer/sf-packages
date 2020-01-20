#!/bin/sh

# purge old, partially uninstalled kernels on Ubuntu
if [ -x /usr/bin/dpkg ] && [ -x /usr/bin/apt-get ]; then
	dpkg -l linux-image* \
		|grep ^rc \
		|cut -d' ' -f3 \
		|grep -v Status \
		|xargs -r apt-get purge -y
fi
