#!/bin/sh

value() {
    grep "^$1=" /tmp/config | head -n1 | cut -d= -f2- | sed 's/[[:blank:]]*$//';
}


iface=`value network_interface`
ip=`value ip_address`
netmask=`value netmask`
gateway=`value default_gateway`
dns=`value dns_server`
ssid=`value ssid_name`
hssid=`value hidden_ssid_name`; [ "$hssid" ] && { ssid="$hssid"; scan_value=1; } || scan_value=0
enc=`value wifi_encryption`
wpa=`value wpa_password`
wep=`value wep_key`
peapu=`value peap_username`
peapp=`value peap_password`
dphone=`value dialup_phone_number`
duser=`value dialup_username`
dpass=`value dialup_password`
wauth=`value wired_authentication`
eapolu=`value eapol_username`
eapolp=`value eapol_password`
