#!/bin/sh
. ./make.env.sh

PORTRON=$(readlink `command -v electron-tgz2iso`)

if [ ! "${PORTRON}" ]; then
    echo "FATAL: Cannot find portron builder"
    exit 1
fi

PORTRONLIB=`dirname ${PORTRON}`/../lib

echo "----------- Making InitRD"
echo "- target distro ${DISTRO}"
echo "- portron lib at ${PORTRONLIB}"

cd ${BASE}/initrd
pwd

if [ -d ${PORTRONLIB}/portron.${1} ]; then
    ${PORTRONBIN}/mknitrd  ${PORTRONLIB}/portron.${1}/boot/initrd.xz
else
    echo "\nUsage: ${0} distroname\n"
    echo "this would create the initrd and save it to the specified distro image,"
    echo "that can then be used by electron-tgz2iso."
    printdistros
fi

