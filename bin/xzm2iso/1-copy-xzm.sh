#!/bin/bash

xzmfile=$1
distro=$2
image=$3

[ -f ${xzmfile} ] && {

    cp -v ${xzmfile} ${distro}/xzm

    if [ ${image} ]; then
        echo "- using image ${image}"
        cp -v ${image} ${distro}/docs/default.jpg
        cp -v ${image} ${distro}/docs/kiosk.jpg
    fi

} || {

    echo "- XZM file not found."

}
