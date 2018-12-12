#!/bin/sh

cd /opt/setup/network
. /etc/profile.d/portron.sh

[ -f /tmp/net-abort ] && {
    rm -f /tmp/net-abort
}

# display critical message $1=icon, $2=message
toast() {
    dunstify -r 100 -u critical -i $1 "$2" 2>/dev/null
}

# display normal message $1=icon, $2=message
toasti() {
    dunstify -r 100 "$1"
}

# display sticky message $1=icon, $2=message
toastp() {
    dunstify -r 100 -t 10000 "$1"
}

# mirar q hace esto
#[ "$DISPLAY" != ":0" -o "`grep aufs /proc/mounts | cut -d' ' -f1 | head -n1`" != aufs ] && sleep 10000 && exit

#version="4.7.0"
#version="`grep kiosk_version /tmp/log/md5 2>/dev/null | head -n1 | cut -d= -f2-`"; [ "$version" ] || { sleep 10000; exit; }


[ `df -h | grep aufs | tr -s ' ' | cut -d' ' -f5 | sed 's/%//'` -gt 30 ] && toast ${DWARN} "WARNING: virtual filesystem size is low. If system installation fails then it could be due to not enough of RAM available on this PC.\nPlease increase the RAM size or do not enable any additional components (e.g. printing) for this machine."

if grep -q 'ID: NOT_AVAILABLE' /etc/version; then
    fmac=`ifconfig -a | grep HWaddr | head -n1 | cut -s -d: -f3- | tr ':' '-'`
    fID="$(echo `echo ${fmac} | cut -c1,3,5,7,9,11,13``echo ${fmac} | rev | cut -c1,3,5,7,9,11,13`)"
    sed -i 's/NOT_AVAILABLE/'${fID}'/g' /etc/version 2>/dev/null
fi

GEN_UUID=`grep ^ID: /etc/version | cut -d' ' -f2`
echo "- pcid $GEN_UUID"

wget="wget --no-http-keep-alive --no-cache --no-check-certificate"

value() {
    grep "^$1=" /tmp/config | head -n1 | cut -d= -f2- | sed 's/[[:blank:]]*$//';
}

runwizard() {

   [ -f /var/run/portron.net.wizard ] || {

       touch /var/run/portron.net.wizard

       ${CMD_NETSETUP} >/dev/null 2>&1

       rm -f /var/run/portron.net.wizard

       [ -f /tmp/net-abort ] || {
            echo "finished wizard, restartin network"
            toastp "Restarting network ... please wait ..."
            . /etc/rc.d/rc.network
            set_network
       }
   }

}

set_network() {

    echo "- set net"

    #/opt/scripts/wizard-now &
    ppac=null

    if [ ! -e /tmp/launch-wizard ]; then
        if [ "$ppac" != fail ]; then

            toasti "Probing Network ..."
            sleep 1
            TRIES=49

            while [ ${TRIES} -gt 0 ]; do
				test -e /tmp/launch-wizard && break; 
				${wget} -q -T20 -t1 -O- ${NEO_URL_PING} | grep -q ${NEO_URL_PING_BEACON} && network=yes && break || {
					toasti "Waiting for Network ... $TRIES secs remaining"
					TRIES=$((TRIES-1))
					sleep 1
				}; 
			done

            if [ ! -e /tmp/launch-wizard ]; then
                if [ ${network} = no ]; then

                    toast ${DWARN} "Network is not responding"
                    sleep 2
                    runwizard
                else
                    toasti "Online"
                    touch /var/run/portron.net.online
                fi
            fi
        fi
    fi
    rm -f /tmp/launch-wizard
}

[ -f /var/run/portron.net.wizard ] && {
    toasti "Network wizard already running"
    exit 0
}

network=no
force=$1

rm /var/run/portron.net.online

while [ "$network" = no ]; do

    if [ ${force} = "force" ]; then

        echo "- forced wizard"
        runwizard

    else

        [ -f ${NEO_CFG_HASNET} ] && {

            # network already configured
            echo "- existing config"

            [ ! -f /var/run/portron.net.started ] && {
                # first-run also starts the network here
                . /etc/rc.d/rc.network
            }

            set_network

        } || {

            # no network configured
            echo "- no network"
            runwizard
        }
    fi



    if [ ${network} = "no" ]; then

        # aborted wizard and non-network
        [ -f /tmp/net-abort ] && {
            exit 1
        }

    fi

done

echo "- End wizard, network ${network}"

