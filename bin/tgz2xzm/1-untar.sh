#!/bin/bash

export tarfile=$1
export appname=$2
export longname=$3
export TMP=/tmp/${appname}.tmp

rm -rf ${TMP}
mkdir -p ${TMP}/opt

cd ${TMP}/opt
tar zxvf ${tarfile}
echo "MOVED FROM ${longname} to ${appname}"
mv ${longname} ${appname}
