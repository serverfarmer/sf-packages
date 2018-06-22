#!/bin/sh
. /etc/farmconfig


install_cpan() {
	pkg=$1
	echo "checking for perl package $pkg"
	if [ "`perl -e \"use $pkg \" 2>&1`" != "" ]; then
		echo "installing package $pkg"
		cpan -fi $pkg
	fi
}



if [ "$1" = "" ]; then
	echo "usage: $0 <package> [package] [...]"
	exit
fi

for package in $@; do
	install_cpan $package
done
