#!/bin/sh

echo "----------- Making InitRD"

BASE="$(cd "$(dirname "$0")"; pwd)"
cd ${BASE}/initrd
pwd

if [ -d ../../lib/${1} ]; then
    ../../bin/mknitrd ../../lib/${1}/boot/initrd.xz
else
    echo "Usage: ${0} distrofolder"
fi

