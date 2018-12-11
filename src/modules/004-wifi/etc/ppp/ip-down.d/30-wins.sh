#!/bin/sh

# Remove WINS servers from smb.conf
# Used parameters and environment variables:
# $1 - interface name (e.g. ppp0)
# $USEPEERWINS - set if user specified usepeerdns
# $WINS1 and $WINS2 - WINS servers reported by peer

if [ "$USEPEERWINS" = 1 -a -f /etc/samba/smb.conf ]; then
	# Remove the WINS servers
	winsservers=
	[ -n "$WINS1" ] && winsservers="$winsservers $1:$WINS1"
	[ -n "$WINS2" ] && winsservers="$winsservers $1:$WINS2"
	sed -i -e "s/^\([[:space:]]*wins[[:space:]]*server[[:space:]]*=[^#]*\) $winsservers /\1/i" /etc/samba/smb.conf

	# Reload nmbd configuration
	smbcontrol nmbd reload-config
fi
