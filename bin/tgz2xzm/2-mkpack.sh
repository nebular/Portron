#!/bin/bash

appname=$1
destination=$2

TMP=/tmp/${appname}.tmp
ROOTIMAGE=../../lib/xzm.fs

[ -d ${TMP} ] && {

    cp -Rv ${ROOTIMAGE}/* ${TMP}/

    ./3-mkscript.sh ${appname}

    chmod +x ${TMP}/opt/bin/*
    ../mkxzm ${destination} ${TMP}

    cd /
    rm -rf ${TMP}
} || {
    echo "- cannot find unpacked temporary at ${TMP}"
}
