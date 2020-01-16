#!/bin/sh
. /etc/farmconfig


install_deb() {
	pkg=$1
	echo "checking for debian package $pkg"
	if [ "`dpkg -l $pkg 2>/dev/null |grep ^ii`" = "" ]; then
		echo "installing package $pkg"
		if [ "$SF_UNATTENDED" != "" ]; then
			apt-get install -y $pkg
		else
			apt-get install $pkg
		fi
	fi
}

install_rpm() {
	pkg=$1
	echo "checking for rpm package $pkg"
	if ! rpm --quiet -q $pkg; then
		echo "installing package $pkg"
		if [ "$SF_UNATTENDED" != "" ]; then
			yum install -y $pkg
		else
			yum install $pkg
		fi
	fi
}

install_suse() {
	pkg=$1
	echo "checking for suse package $pkg"
	if ! rpm --quiet -q $pkg; then
		echo "installing package $pkg"
		if [ "$SF_UNATTENDED" != "" ]; then
			aptitude install -y $pkg
		else
			aptitude install $pkg
		fi
	fi
}

install_pkg() {
	pkg=$1
	echo "checking for freebsd package $pkg"
	if [ "`pkg info |grep ^$pkg-`" = "" ]; then
		echo "installing package $pkg"
		if [ "$SF_UNATTENDED" != "" ]; then
			pkg-static install -y $pkg
		else
			pkg-static install $pkg
		fi
	fi
}

install_pkgin() {
	pkg=$1
	echo "checking for netbsd package $pkg"
	if [ "`pkgin list |grep ^$pkg-`" = "" ]; then
		echo "installing package $pkg"
		if [ "$SF_UNATTENDED" != "" ]; then
			pkgin -y install $pkg
		else
			pkgin install $pkg
		fi
	fi
}

install_ipkg() {
	pkg=$1
	echo "checking for optware ipkg package $pkg"
	if [ "`ipkg list_installed |grep ^\"$pkg -\"`" = "" ]; then
		echo "installing package $pkg"
		ipkg install $pkg
	fi
}


if [ "$1" = "" ]; then
	echo "usage: $0 <package> [package] [...]"
	exit
fi

for package in $@; do
	if [ "$OSTYPE" = "debian" ]; then
		install_deb $package
	elif [ "$OSTYPE" = "redhat" ] || [ "$OSTYPE" = "amazon" ]; then
		install_rpm $package
	elif [ "$OSTYPE" = "suse" ]; then
		install_suse $package
	elif [ "$OSTYPE" = "netbsd" ]; then
		install_pkgin $package
	elif [ "$OSTYPE" = "freebsd" ]; then
		install_pkg $package
	elif [ "$OSTYPE" = "qnap" ]; then
		install_ipkg $package
	fi
done
