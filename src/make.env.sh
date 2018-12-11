#!/bin/sh
export PORTRON=$(readlink `command -v electron-tgz2iso`)

if [ ! "${PORTRON}" ]; then
    echo "FATAL: Cannot find portron builder"
    exit 1
fi

PORTRONLIB=`dirname ${PORTRON}`/../lib

export BASE="$(cd "$(dirname "${0}")"; pwd)"
export PORTRONDIR="$(cd "$(dirname "${PORTRONLIB}")"; pwd)"
export PORTRONLIB="${PORTRONDIR}/lib"
export PORTRONBIN="${PORTRONDIR}/bin"


printdistros() {
    echo "\nAvailable installed distros:"
    for i in $(ls -d  ${PORTRONLIB}/portron.*/); do echo `basename ${i%%/}`; done
}