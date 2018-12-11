#!/bin/sh

cd /opt/setup/network

source /etc/profile.d/portron


value() {
    grep "^$1=" /tmp/config | head -n1 | cut -d= -f2- | sed 's/[[:blank:]]*$//';
}

generate() {
    val=`value ${4}`
    generateVal "$1" $2 $3 "${val}"
}

generateVal() {

    dest=${1}/${3}
    delete=${2}
    val=${4}

    if [ "${val}" ]; then
        echo "- generating $3 = ${val}"
        echo "${val}" > ${dest}
    else
        # not existent value
        if [ "${delete}" = yes ]; then
            rm ${dest}
        fi
    fi

}

writevalues() {

    [ -d $1$ ] || mkdir -p $1

    echo "- generating in DIR $1"
    
    generate "$1" no NET_connection connection
    generate "$1" no NET_dhcp dhcp
    generate "$1" no NET_iface network_interface
    generate "$1" no NET_ip ip_address
    generate "$1" no NET_netmask netmask
    generate "$1" no NET_gateway  default_gateway
    generate "$1" no NET_dns dns_server
    generate "$1" no NET_enc wifi_encryption
    generate "$1" no NET_wpa wpa_password
    generate "$1" no NET_wep wep_key
    generate "$1" no NET_peapu peap_username
    generate "$1" no NET_peapp peap_password
    generate "$1" no NET_dphone dialup_phone_number
    generate "$1" no NET_duser dialup_username
    generate "$1" no NET_dpass dialup_password
    generate "$1" no NET_wauth wired_authentication
    generate "$1" no NET_eapolu eapol_username
    generate "$1" no NET_eapolp eapol_password

    HSSID=`value ${hidden_ssid_name}`

    if [ "${HSSID}" ]; then
        generateVal "$1" no NET_ssid "${HSSID}"
        generateVal "$1" no NET_scan_value 1
    else
        generate "$1" no NET_ssid ssid_name
        generateVal "$1" no NET_scan_value 0
    fi

}


writevalues $1

sync
