#!/bin/sh
. /etc/farmconfig


uninstall_deb() {
	pkg=$1
	if [ "`dpkg -l $pkg 2>/dev/null |egrep \"^(ii|rc)\"`" != "" ]; then
		echo "uninstalling package $pkg"
		if [ "$SF_UNATTENDED" != "" ]; then
			apt-get purge -y $pkg
		else
			apt-get purge $pkg
		fi
	fi
}

uninstall_rpm() {
	pkg=$1
	if rpm --quiet -q $pkg; then
		echo "uninstalling package $pkg"
		rpm -e $pkg
	fi
}

uninstall_pkg() {
	pkg=$1
	if [ "`pkg info |grep ^$pkg-`" != "" ]; then
		echo "uninstalling package $pkg"
		if [ "$SF_UNATTENDED" != "" ]; then
			pkg-static delete -y $pkg
		else
			pkg-static delete $pkg
		fi
	fi
}

uninstall_pkgin() {
	pkg=$1
	if [ "`pkgin list |grep ^$pkg-`" != "" ]; then
		echo "uninstalling package $pkg"
		if [ "$SF_UNATTENDED" != "" ]; then
			pkgin -y remove $pkg
		else
			pkgin remove $pkg
		fi
	fi
}

uninstall_ipkg() {
	pkg=$1
	if [ "`ipkg list_installed |grep ^\"$pkg -\"`" != "" ]; then
		echo "uninstalling package $pkg"
		ipkg remove $pkg
	fi
}


if [ "$1" = "" ]; then
	echo "usage: $0 <package> [package] [...]"
	exit
fi

if [ -x ~/.serverfarmer/hooks/pre-upgrade.sh ]; then
	~/.serverfarmer/hooks/pre-upgrade.sh --uninstall
fi

for package in $@; do
	if [ "$OSTYPE" = "debian" ]; then
		uninstall_deb $package
	elif [ "$OSTYPE" = "redhat" ] || [ "$OSTYPE" = "amazon" ] || [ "$OSTYPE" = "suse" ]; then
		uninstall_rpm $package
	elif [ "$OSTYPE" = "netbsd" ]; then
		uninstall_pkgin $package
	elif [ "$OSTYPE" = "freebsd" ]; then
		uninstall_pkg $package
	elif [ "$OSTYPE" = "qnap" ]; then
		uninstall_ipkg $package
	fi
done

if [ -x ~/.serverfarmer/hooks/post-upgrade.sh ]; then
	~/.serverfarmer/hooks/post-upgrade.sh --uninstall
fi
