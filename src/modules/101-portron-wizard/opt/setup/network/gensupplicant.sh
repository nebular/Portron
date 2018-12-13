#!/bin/bash

. /opt/bin/loadvalues NET

umask 200

if [ "${NET_ssid}" ]; then

    echo "- generating network supplicant"
    
    if [ "${NET_enc}" = wpa ]; then

        PSK=`wpa_passphrase "${NET_ssid}" "${NET_wpa}" | grep psk=[a-f,0-9] | cut -d= -f2`

        cat > ${NEO_GEN_NETSUPPLICANT} << EOF
        ctrl_interface=/var/run/wpa_supplicant
        ctrl_interface_group=0
        eapol_version=1
        ap_scan=1

        network={
            scan_ssid=${NET_scan_value}
            ssid="${NET_ssid}"
            key_mgmt=WPA-PSK
            psk=${PSK}
        }
EOF

    elif [ "${NET_enc}" = eap-peap ]; then

        cat > ${NEO_GEN_NETSUPPLICANT} << EOF
        ctrl_interface=/var/run/wpa_supplicant
        ctrl_interface_group=0
        eapol_version=1
        ap_scan=1
        network={
            scan_ssid=${NET_scan_value}
            ssid="${NET_ssid}"
            key_mgmt=WPA-EAP
            eap=PEAP
            identity="${NET_peapu}"
            password="${NET_peapp}"
            phase2="auth=MSCHAPV2"
        }
EOF

    elif [ "${enc}" = wep ]; then
        cat > ${NEO_GEN_NETSUPPLICANT} << EOF
        ctrl_interface=/var/run/wpa_supplicant
        ctrl_interface_group=0
        eapol_version=1
        ap_scan=1
        network={
            scan_ssid=${NET_scan_value}
            ssid="${NET_ssid}"
            key_mgmt=NONE
            wep_key0=${NET_wep}
            wep_tx_keyidx=0
        }
EOF
    else
        cat > ${NEO_GEN_NETSUPPLICANT} << EOF
        ctrl_interface=/var/run/wpa_supplicant
        ctrl_interface_group=0
        eapol_version=1
        ap_scan=1
        network={
            scan_ssid=${NET_scan_value}
            ssid="${NET_ssid}"
            key_mgmt=NONE
        }
EOF

    fi

fi

umask 222
