#!/bin/sh
#
# This file is executed by init(8) when the system is being
# initialized for one of the "multi user" run levels (i.e.
# levels 1 through 6).
# Author: T.Jokiel <http://porteus-kiosk.org>

# Start cron and logging daemon:
/usr/sbin/crond &

fecha=`date`
logger "* ${fecha} Multiuser runlevel rc.M"

# Start messagebus:
/usr/bin/dbus-uuidgen --ensure=/etc/machine-id
/usr/bin/dbus-daemon --system &

# Enable ACPI events (e.g. possibility of shutting down the kiosk by pressing a PC's power button):
/usr/sbin/acpid -n >/dev/null &

# Initialize swap partitions:
#for swpprt in `blkid | grep ' TYPE="swap"' | cut -d: -f1`; do swapon $swpprt; done

# Initialize swapfile:
#swapsize=1024
if [ "$swapsize" ]; then
    sh /opt/boot/persistence
    # Make sure that persistent partition is mounted so we wont fill the RAM:
    if grep -q -w '/opt/storage xfs' /proc/mounts; then
	# Create swapfile if it does not exist or its size is different than configured:
	if [ -e /opt/storage/swapfile ]; then
	    sfsize="$((`du /opt/storage/swapfile | cut -d/ -f1`/1024))"
	    [ $sfsize = $swapsize ] || { dd < /dev/zero > /opt/storage/swapfile bs=1M count=$swapsize 2>/dev/null; mkswap /opt/storage/swapfile >/dev/null; }
	else
	    dd < /dev/zero > /opt/storage/swapfile bs=1M count=$swapsize 2>/dev/null; mkswap /opt/storage/swapfile >/dev/null
	fi
	# Recreate swap file if needed:
	swapon /opt/storage/swapfile || { dd < /dev/zero > /opt/storage/swapfile bs=1M count=$swapsize 2>/dev/null; mkswap /opt/storage/swapfile >/dev/null; swapon /opt/storage/swapfile; }
    fi
fi

# Initialize zRAM:
#zsize=33%
if [ "$zsize" ]; then
    modprobe zram; mem=$((`grep MemTotal /proc/meminfo | cut -d" " -f2- | sed s/kB//`/100)); size=`echo $zsize | sed 's/%//g'`
    echo $(($mem*1024*$size)) > /sys/block/zram0/disksize
    mkswap /dev/zram0 >/dev/null
    swapon -p 100 /dev/zram0
fi
