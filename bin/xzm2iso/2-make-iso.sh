#!/bin/bash

appname=$1
distro=$2
destination=$3

[ -f ${distro}/make_iso.sh ] && {

    cd ${distro}


    ./make_iso.sh

    cd ..
    echo "- Building HYBRID ISO UEFI for ${appname}"
    ../bin/isohybrid/isohybrid -u Porteus-Kiosk.iso
    rm -f ${destination}
    mv Porteus-Kiosk.iso ${destination}
    echo "- created ${destination}"

} || {

    echo "- distro not found at ${distro}"

}
