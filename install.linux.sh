#!/bin/bash
apt-get install squashfs-tools
cd bin/isohybrid/src
./make.sh
cd ..
mksquashfs --version
./isohybrid --version
echo "Dependencies should be installed."
