#!/bin/bash

echo "----------- Making Modules"

BASE="$(cd "$(dirname "$0")"; pwd)"
cd ${BASE}/modules
pwd

if [ -d ../../lib/${1} ]; then

    [ -d /tmp/extraxzm ] && rm -rf /tmp/extraxzm
    mkdir /tmp/extraxzm

    #../bin/mkxzm /tmp/extraxzm/000-kernel.xzm 000-kernel
    ../../bin/mkxzm /tmp/extraxzm/002-system.xzm 002-system
    ../../bin/mkxzm /tmp/extraxzm/003-theme.xzm 003-theme
    ../../bin/mkxzm /tmp/extraxzm/99-xterm.xzm 99-xterm
    ../../bin/mkxzm /tmp/extraxzm/100-portron.xzm 100-portron
    ../../bin/mkxzm /tmp/extraxzm/101-portron-wizard.xzm 101-portron-wizard

    cp -v /tmp/extraxzm/*.xzm ../../lib/$1/xzm/
    rm -rf /tmp/extraxzm

else
    echo "Usage: ${0} distrofolder"
fi

