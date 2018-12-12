#!/bin/bash

appname=$1
distro=$2
destination=$3

[ -f ${distro}/make_iso.sh ] && {


    cd ${distro}
    rm -f ../Portron.${1}.iso
    ./make_iso.sh ../Portron.${1}.iso
    pwd
    cd ..
    echo "- Building HYBRID ISO UEFI for ${appname}"
    ${PORTRONBIN}/isohybrid/isohybrid -u Portron.${1}.iso

    if [ -f Portron.${1}.iso ]; then
        [ -f ${destination} ] && rm -f ${destination}
        mv Portron.${1}.iso ${destination}
        echo "- created ${destination}"
    else
        echo "- error generating iso"
        exit 1
    fi
} || {

    echo "- distro not found at ${distro}"
    exit 1
}
