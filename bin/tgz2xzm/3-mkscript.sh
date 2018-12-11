#!/bin/bash

export appname=$1
export TMP=/tmp/${appname}.tmp

DIRE=${TMP}/var/run/conf.d
FILE=${DIRE}/CFG_PRODUCT


echo "${appname}" > ${FILE}
