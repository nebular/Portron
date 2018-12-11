#!/bin/sh

BASE="$(cd "$(dirname "$0")"; pwd)"
cd ${BASE}

./make.init.sh portron.default
./make.modules.sh portron.default



