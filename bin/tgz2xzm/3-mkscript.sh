#!/bin/bash

export appname=$1
export TMP=/tmp/${appname}.tmp

DIRE=${TMP}/etc/conf.d
FILE=${DIRE}/CFG_PRODUCT
mkdir -p ${DIRE}

echo "${appname}" > ${FILE}
