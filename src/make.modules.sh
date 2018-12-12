#!/bin/bash

. make.env.sh

TARGET=${PORTRONLIB}/portron.${1}

if [ -d ${TARGET} ]; then

    rm ${TARGET}/xzm
    [ -d ${TARGET}/xzm ] && rm -rf  ${TARGET}/xzm
    mkdir -p ${TARGET}/xzm
    cd modules
    ${PORTRONBIN}/mkxzm ${TARGET}/xzm/000-kernel.xzm 000-kernel
    ${PORTRONBIN}/mkxzm ${TARGET}/xzm/001-core.xzm 001-core
    ${PORTRONBIN}/mkxzm ${TARGET}/xzm/002-system.xzm 002-system
    ${PORTRONBIN}/mkxzm ${TARGET}/xzm/003-theme.xzm 003-theme
    ${PORTRONBIN}/mkxzm ${TARGET}/xzm/004-wifi.xzm 004-wifi
    ${PORTRONBIN}/mkxzm ${TARGET}/xzm/99-xterm.xzm 99-xterm
    ${PORTRONBIN}/mkxzm ${TARGET}/xzm/100-portron.xzm 100-portron
    ${PORTRONBIN}/mkxzm ${TARGET}/xzm/101-portron-wizard 101-portron-wizard
    cd ..
else
    echo "Usage: ${0} distro \n"
    echo "- compiles and copies the modules to the specified distro"
    echo "- use default as the default distro"
    printdistros

fi

