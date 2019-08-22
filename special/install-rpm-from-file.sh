#!/bin/sh
. /etc/farmconfig

if [ "$2" = "" ]; then
	echo "usage: $0 <package> <rpm-file>"
	exit 0
elif [ "`which rpm`" = "" ]; then
	echo "error: rpm not found"
	exit 0
fi

pkg=$1
file=$2

echo "checking for rpm package $pkg"
if rpm --quiet -q $pkg; then
	exit 0
elif [ -s $file ]; then
	echo "installing package $pkg from file `basename $file`"
	rpm -i $file
else
	echo "error: file $file not found"
fi
