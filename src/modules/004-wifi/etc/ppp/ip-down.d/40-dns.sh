#!/bin/sh

# Restore DNS resolver settings
# Used parameters and environment variables:
# $1 - interface name (e.g. ppp0)
# $USEPEERDNS - set if user specified usepeerdns

if [ "$USEPEERDNS" ]; then
	if [ -x /sbin/resolvconf ]; then
		/sbin/resolvconf -d "$1"
	else
		# taken from debian's 0000usepeerdns
		# follow any symlink to find the real file
		REALRESOLVCONF=$(readlink -f /etc/resolv.conf)

		if [ "$REALRESOLVCONF" != "/etc/ppp/resolv.conf" ]; then

			# if an old resolv.conf file exists, restore it
			if [ -e $REALRESOLVCONF.pppd-backup ]; then
				mv $REALRESOLVCONF.pppd-backup $REALRESOLVCONF
			fi

		fi
	fi
fi
