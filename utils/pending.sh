#!/bin/sh
. /etc/farmconfig


if [ "$OSTYPE" = "debian" ]; then
	apt-get --dry-run upgrade 2>/dev/null |grep ^'Inst ' |cut -d' ' -f2
elif [ "$OSTYPE" = "redhat" ] || [ "$OSTYPE" = "amazon" ]; then
	yum list updates 2>/dev/null |awk '{ if (($3=="base") || ($3=="updates")) print $1 }' |sed -e s/.noarch//g -e s/.x86_64//g -e s/.i686//g
elif [ "$OSTYPE" = "suse" ]; then
	aptitude list-updates |grep '^v |' |awk '{ print $5 }'
elif [ "$OSTYPE" = "netbsd" ]; then
	pkgin -n upgrade |grep -A1000 "to be installed" |grep -v "to be installed" |grep -v ^$ |rev |cut -d- -f2- |rev
elif [ "$OSTYPE" = "freebsd" ]; then
	pkg-static upgrade --dry-run |grep " -> " |grep -v "ABI changed" |awk '{ print $1 }' |sed s/://g
fi
