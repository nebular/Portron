#!/bin/sh

. make.env.sh

if [ ! "$1" ]; then
    echo "Usage: ${0} distro_name\n"
    echo "- creates a new distro into the Portron Library. You can later on build your applications using"
    echo "  this distro. This command will create the structure, build all modules and compile the initrd."
    exit 1
fi

BASE="$(cd "$(dirname "$0")"; pwd)"
cd ${BASE}

./make.distro.sh $1 && ./make.init.sh $1 && ./make.modules.sh $1




