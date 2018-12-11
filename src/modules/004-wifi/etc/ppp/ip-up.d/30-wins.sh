#!/bin/sh

# Handle smb.conf updating when the usepeerwins pppd option is being used.
# Used parameters and environment variables:
# $1 - interface name (e.g. ppp0)
# $USEPEERWINS - set if user specified usepeerdns
# $WINS1 and $WINS2 - WINS servers reported by peer
# Will additionally "tag" the wins servers, as explained in smb.conf(5), using the $1 value.

if [ "$USEPEERWINS" = 1 -a -f /etc/samba/smb.conf ]; then
	# Add global section if it is needed
	grep -qi '\[[[:space:]]*global[[:space:]]*\]' /etc/samba/smb.conf \
		|| sed -i -e '1i[global]' /etc/samba/smb.conf
    
	# Add wins server line if is missing
	grep -qi '^[[:space:]]*wins[[:space:]]*server[[:space:]]*=' /etc/samba/smb.conf \
		|| sed -i -e '/\[[[:space:]]*global[[:space:]]*\]/a\    wins server =' /etc/samba/smb.conf

	# Set the WINS servers
	winsservers=
	[ -n "$WINS1" ] && winsservers="$winsservers $1:$WINS1"
	[ -n "$WINS2" ] && winsservers="$winsservers $1:$WINS2"
	sed -i -e "s/^\([[:space:]]*wins[[:space:]]*server[[:space:]]*=[^#]*\)/\1 $winsservers /i" /etc/samba/smb.conf

	# Reload nmbd configuration
	smbcontrol nmbd reload-config
fi
