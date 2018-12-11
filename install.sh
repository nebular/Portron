#!/bin/sh

installisohybrid() {

    cd bin/isohybrid/src
    . ./make.sh
    cd ..

 }

linkshit() {

    echo "- creating portron symlinks from ${BASE}"
    [ -f /usr/local/bin/electron-tgz2iso ] && rm -f /usr/local/bin/electron-tgz2iso
    cd  ${BASE}/bin
    [ -d /usr/local/bin ] || mkdir -p /usr/local/bin
    ln -s ${BASE}/bin/electron-tgz2iso /usr/local/bin/electron-tgz2iso || {
        echo "- ERROR: Cannot create symbolic link of electron-tgz2iso to /usr/local/bin, maybe permissions?"
        exit 1
    }
}

echo "Portron Builder installation"

BASE="$(cd "$(dirname "$0")"; pwd)"
cd ${BASE}

if [ ! "`command -v mksquashfs`" ]; then

    if [ "`command -v apt-get`" ]; then

        apt-get update && apt-get install squashfs

    elif [ "`command -v brew`" ]; then

        echo "- OSX detected, using brew"
        brew install squashfs gcc

    else

        echo "- ERROR: Please install squashfs (mksquashfs tool) using your distro archiver"
        exit 1

    fi

fi

echo "- Building isohybrid"
cd ${BASE}/bin/isohybrid/src
./make.sh
cd ..

if [ "`command -v mksquashfs`" ]; then
    # success installing mksquashfs
    echo "- success installing mksquashfs"
    if [ -f ./isohybrid ]; then

        # success installing isohybrid
        echo "- success installing isohybrid"
        linkshit
        echo "- Installation complete."
        exit 0
    fi
fi

echo "Error, installation not complete."
