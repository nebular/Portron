#!/bin/sh
. ./make.env.sh

if [ ! "${1}" ]; then
    echo "USAGE: ${0} distroname"
    echo "- creates a blank distro in Portron Library ($PORTRONLIB)"
    echo "  without any modules"
    exit 1
fi

TARGET=${PORTRONLIB}/portron.${1}

if [ -d ${TARGET} ]; then
    echo "Distro ${TARGET} already exists. Delete it manually and rerun the command."
    exit 2
fi

[ -d ${TARGET} ] && rm -rf TARGET
mkdir ${TARGET}
cp -aR ${BASE}/template/* ${TARGET} && {
    echo "Distribution ${1} initialized"
    ls -lah ${TARGET}
}

