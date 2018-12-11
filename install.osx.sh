#!/bin/bash
brew install squashfs
cd bin/isohybrid/src
./make.sh
cd ..
mksquashfs --version
./isohybrid --version
echo "Dependencies should be installed."
