#!/bin/sh
. ./make.env.sh

PORTRON=$(readlink `command -v electron-tgz2iso`)

if [ ! "${PORTRON}" ]; then
    echo "FATAL: Cannot find portron builder. You must run the install.sh script"
    exit 1
fi

PORTRONLIB=`dirname ${PORTRON}`/../lib

cd ${BASE}/initrd
pwd

echo "----------- Building InitRD"
echo "- portron lib at ${PORTRONLIB}"

if [ -d ${PORTRONLIB}/portron.${1} ]; then
    echo "- target distro portron.${1}"
    ${PORTRONBIN}/mknitrd ${PORTRONLIB}/portron.${1}/boot/initrd.xz
    echo "- initrd.xz on portron.${1} updated"
else
    echo "\nUsage: ${0} distroname\n"
    echo "this would create the initrd and save it to the specified distro image,"
    echo "that can then be used by electron-tgz2iso."
    printdistros
fi

