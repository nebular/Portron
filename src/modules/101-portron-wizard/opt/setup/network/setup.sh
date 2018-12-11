#!/bin/bash

# Kiosk Wizard - A wizard for settings and features in Porteus Kiosk
# Copyright (C) 2014-2020 Jay Flood (aka brokenman)
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
# Project Page: http://porteus-kiosk.orgåå
# Wizard functionality extended by Tomasz Jokiel <admin@porteus-kiosk.org>


## ====================================================================
## variables
## ====================================================================
SCRIPT="$(cd "${0%/*}" 2>/dev/null; echo "$PWD"/"${0##*/}")"

export TMP=/tmp/knet
export CONF=/tmp/config
export REPORT=/tmp/report

ICONS=/usr/share/pixmaps
WINWIDTH=840
WINHEIGHT=620
TXTWIDTH=$(( WINWIDTH - 20 ))
HALFWIDTH=400
PAGEHEIGHT=560

BUTNEXT=/usr/share/icons/oxygen/16x16/actions/go-next.png
BUTPREV=/usr/share/icons/oxygen/16x16/actions/go-previous.png
WIN_TITLE=""
WIN_HEADER="Configure Network"

cd /opt/setup/network

## ====================================================================
## Functions
## ====================================================================

cleanup(){
    [ -d ${TMP} ] && rm -rf ${TMP}
    [ -e ${REPORT} ] && rm ${REPORT}
    unset SCRIPT SPATH TMP CONF WINWIDTH TXTWIDTH BUTNEXT BUTPREV IMAGEONE IMAGETWO IMGPASS WIZARD_PRE
    unset ipadress mask gateway dns1 essid wencryption device wifi_encryption key
    exit
}

go_dhcp() {
    [ ! `grep dhcp ${CONF}` ] && echo "dhcp=yes" >> ${CONF}
}

## ====================================================================
## Main dialog
## ====================================================================

## Trap exits
trap 'cleanup' 2 14 15

## Setup files required

[ -d ${TMP} ] && rm -rf ${TMP}
mkdir ${TMP}
echo 0 > ${TMP}/.knetPage
echo > ${TMP}/device
echo true > ${TMP}/proxyExcDis.mon
echo "Scanning ... please wait" > ${TMP}/essid

export IMAGEONE="/usr/share/icons/oxygen/22x22/actions/gtk-no.png"
export IMAGETWO="/usr/share/icons/oxygen/22x22/actions/gtk-ok.png"
export IMGPASS=${TMP}/img.png

cp -L ${IMAGEONE} ${TMP}/img.png
touch ${REPORT} ${TMP}/encryption.tmp ${TMP}/authtype.tmp

# Remove close button from the windows bar:
sed -i 's_<titleLayout>LC</titleLayout>_<titleLayout>L</titleLayout>_g' /etc/xdg/openbox/rc.xml
openbox --reconfigure

export WIZARD_PRE='
<window decorated="true" title="'${WIN_TITLE}'" icon-name="kiosk" resizable="false" width-request="'${WINWIDTH}'" height-request="'${WINHEIGHT}'">
<vbox  margin="5">
## ================ WIRED OR WIRELESS CHOICE 0 ================ ##
<notebook height-request="'${PAGEHEIGHT}'" page="0" show-tabs="false" show-border="false" labels="connection|config|manual|wificonfig|proxy|report">
<vbox>
	<text use-markup="true" yalign="1">
	    <label>"<span weight='"'bold'"' size='"'x-large'"'>'${WIN_HEADER}'</span>"</label>
	</text>
	<text><label>""</label></text>
	<hseparator></hseparator>
	<text yalign="0" xalign="0" wrap="true" width-request="'${TXTWIDTH}'">
		<label>Please choose one of the options below to setup your internet connection. You can also change your keyboard layout, or open a virtual keyboard,  with the buttons at the bottom.</label>
	</text>
	<hseparator></hseparator>
	<text><label>""</label></text>
	<text><label>""</label></text>
	<hbox>
		<button image-position="2" tooltip-text="Connect using a wired connection">
			<width>160</width>
			<height>160</height>
			<input file>'${ICONS}'/wired-160.png</input>
			<label>Select ethernet connection</label>
			<action>echo "connection=wired" > $TMP/connection.tmp</action>
## <------- This action echos page 2 to the page monitor then refreshes the interface
			<action>echo 2 > '${TMP}'/.knetPage</action>
			<action function="enable">butBack</action>
			<action function="hide">butKbdLayout</action>
			<action function="show">authtype</action>
			<action function="show">AUsername</action>
			<action function="show">APassword</action>
			<action function="show">a1</action>
			<action function="show">a2</action>
			<action function="disable">proxyExcEn</action>
			<action function="disable">proxyExcDis</action>
			<action function="disable">proxyExcList</action>
			<action>echo true > '${TMP}'/proxyExcDis.mon</action>
		    <action function="hide">butAbort</action>
    		<action function="show">butBack</action>
			<action>refresh:nPage</action>
		</button>
		<button image-position="2" tooltip-text="Connect using a wireless connection">
			<width>160</width>
			<height>160</height>
			<input file>'${ICONS}'/wifi-160.png</input>
			<label>Select wireless connection</label>
			<action>echo "connection=wifi" > $TMP/connection.tmp</action>
## <------- Start scanning for available SSIDs
			<action>get_essid &</action>
			<action>echo 2 > '${TMP}'/.knetPage</action>
			<action function="enable">butBack</action>
    		<action function="show">butBack</action>
			<action function="hide">butKbdLayout</action>
			<action function="hide">authtype</action>
			<action function="hide">AUsername</action>
			<action function="hide">APassword</action>
			<action function="hide">a1</action>
			<action function="hide">a2</action>
		    <action function="hide">butAbort</action>
			<action function="disable">proxyExcEn</action>
			<action function="disable">proxyExcDis</action>
			<action function="disable">proxyExcList</action>
			<action>echo true > '${TMP}'/proxyExcDis.mon</action>
			<action>refresh:nPage</action>
		</button>
		<button image-position="2" tooltip-text="Connect using a dialup connection">
			<width>160</width>
			<height>160</height>
			<input file>'${ICONS}'/dialup.png</input>
			<label>Select dial-up  connection   </label>
			<action>echo "connection=dialup" > $TMP/connection.tmp</action>
## <------- This action echos page 1 to the page monitor then refreshes the interface
			<action>echo 1 > '${TMP}'/.knetPage</action>
		    <action function="hide">butAbort</action>
    		<action function="show">butBack</action>
			<action function="enable">butBack</action>
			<action function="enable">butForth</action>
			<action function="hide">butKbdLayout</action>
			<action>refresh:nPage</action>
		</button>
		<text width-request="5"><label>""</label></text>
	</hbox>
	<text><label>""</label></text>
	<text><label>""</label></text>
	<text><label>""</label></text>
</vbox>

## ================== DIALUP CONFIGURATION 1 ================== ##
<vbox>
	<text use-markup="true" yalign="1"><label>"<span weight='"'bold'"' size='"'x-large'"'>Modem Configuration</span>"</label></text>
	<hseparator></hseparator>
	<text><label>""</label></text>
	<text yalign="0" xalign="0" wrap="true" width-request="'${TXTWIDTH}'">
		<label>Provide settings for your wired/mobile (2G/3G) dialup modem below.</label>
	</text>
	<text><label>""</label></text>
	<hbox>
		<text><label>Phone number:	</label></text>
		<entry editable="true" activates_default="true">
			<default>*99#</default>
			<variable>pphone</variable>
		</entry>
	</hbox>
	<hbox>
		<text><label>Username:		</label></text>
		<entry editable="true" activates_default="true">
			<default>vodafone</default>
			<variable>puser</variable>
		</entry>
	</hbox>
	<hbox>
		<text><label>Password:		</label></text>
		<entry editable="true" activates_default="true">
			<default>vodafone</default>
			<variable>ppass</variable>
		</entry>
	</hbox>
</vbox>



## ================= DHCP OR MANUAL CHOICE  2 ================= ##
<vbox>
	<text use-markup="true" yalign="1"><label>"<span weight='"'bold'"' size='"'x-large'"'>Network Configuration Type</span>"</label></text>
	<hseparator></hseparator>
	<text yalign="0" xalign="0" wrap="true" width-request="'${TXTWIDTH}'">
		<label>Choose DHCP if you would like your network configuration to be automatically setup. Choose manual if you would like to enter your network configuration manually.</label>
	</text>
	<hseparator></hseparator>
	<text><label>""</label></text>
	<hbox>
		<button width-request="'${HALFWIDTH}'" image-position="2" tooltip-text="Configure network automatically">
			<width>160</width>
			<height>160</height>
			<input file>'${ICONS}'/internet-160.png</input>
			<label>Configure connection using DHCP</label>
			<action>echo "dhcp=yes" > $TMP/dhcp.tmp</action>
			<action condition="command_is_true( [ `grep -o wired $TMP/connection.tmp` ] && echo true )">get_report</action>
			<action condition="command_is_true( [ `grep -o wired $TMP/connection.tmp` ] && echo true )">echo 6 > $TMP/.knetPage</action>
			<action condition="command_is_true( [ `grep -o wifi $TMP/connection.tmp` ] && echo true )">echo 4 > $TMP/.knetPage</action>
			<action condition="command_is_true( [ `grep -o wifi $TMP/connection.tmp` ] && echo true )">show:butSetClock</action>
			<action condition="command_is_true( [ `grep -o wifi $TMP/connection.tmp` ] && echo true )">show:butScanWifi</action>
			<action function="enable">butForth</action>
			<action>refresh:nPage</action>
			<action function="enable">proxy</action>
			<action function="enable">proxypac</action>
		</button>
		<button width-request="'${HALFWIDTH}'" image-position="2" tooltip-text="Configure network manually">
			<width>160</width>
			<height>160</height>
			<input file>'${ICONS}'/network-configuration-160.png</input>
			<label>Configure connection manually</label>
			<action>'get_device'</action>
			<action>echo 3 > '${TMP}'/.knetPage</action>
			<action function="enable">butForth</action>
			<action>refresh:nPage</action>
		</button>
	</hbox>
	<text><label>""</label></text>
	<hseparator></hseparator>
	<comboboxtext>
		<item>Wired authentication ( Default is: no authentication )</item>
		<item>EAP over LAN (802.1x) authentication</item>
		<variable>authtype</variable>
		<action signal="changed">echo "$authtype" | grep 802.1x && echo "wired_authentication=eapol" > $TMP/authtype.tmp || echo > $TMP/authtype.tmp</action>
		<action condition="command_is_true( [ `grep -c eapol $TMP/authtype.tmp` = 1 ] && echo true )" function="enable">a1</action>
		<action condition="command_is_true( [ `grep -c eapol $TMP/authtype.tmp` = 1 ] && echo true )" function="enable">AUsername</action>
		<action condition="command_is_true( [ `grep -c eapol $TMP/authtype.tmp` = 1 ] && echo true )" function="enable">a2</action>
		<action condition="command_is_true( [ `grep -c eapol $TMP/authtype.tmp` = 1 ] && echo true )" function="enable">APassword</action>
		<action condition="command_is_true( [ `grep -c eapol $TMP/authtype.tmp` = 0 ] && echo true )" function="disable">a1</action>
		<action condition="command_is_true( [ `grep -c eapol $TMP/authtype.tmp` = 0 ] && echo true )" function="disable">AUsername</action>
		<action condition="command_is_true( [ `grep -c eapol $TMP/authtype.tmp` = 0 ] && echo true )" function="disable">a2</action>
		<action condition="command_is_true( [ `grep -c eapol $TMP/authtype.tmp` = 0 ] && echo true )" function="disable">APassword</action>
		<action condition="command_is_true( [ `grep -c eapol $TMP/authtype.tmp` = 0 ] && echo true )">rm -f $TMP/authtype.tmp $TMP/eapol-username.tmp $TMP/eapol-password.tmp</action>
	</comboboxtext>
	<hbox>
		<text visibility="true" sensitive="false">
		    <variable>AUsername</variable>
		    <label>Username:		</label>
		</text>
		<entry visibility="true" sensitive="false" editable="true" activates_default="true">
		<variable>a1</variable>
		<action signal="changed">echo "eapol_username=$a1" > $TMP/eapol-username.tmp</action>
		</entry>
	</hbox>
	<hbox>
		<text visibility="true" sensitive="false">
		    <variable>APassword</variable>
		    <label>Password:		</label>
		</text>
		<entry visibility="true" sensitive="false" editable="true" activates_default="true">
		<variable>a2</variable>
		<action signal="changed">echo "eapol_password=$a2" > $TMP/eapol-password.tmp</action>
		</entry>
	</hbox>
	<text><label>""</label></text>
</vbox>



## ================== MANUAL CONFIGURATION 3 ================== ##
<vbox>
	<text use-markup="true" yalign="1"><label>"<span weight='"'bold'"' size='"'x-large'"'>Manual Configuration</span>"</label></text>
	<hseparator></hseparator>
	<text><label>""</label></text>
	<text yalign="0" xalign="0" wrap="true" width-request="'${TXTWIDTH}'">
		<label>Please enter your manual configuration options below.</label>
	</text>
	<text><label>""</label></text>
	<hbox>
		<text><label>Interface:		</label></text>
		<comboboxtext width-request="446" file-monitor="'${TMP}'/device" auto-refresh="true">
			<input file>'${TMP}'/device</input>
			<variable>device</variable>
		</comboboxtext>
	</hbox>
	<hbox>
		<text><label>IP Address:		</label></text>
		<entry editable="true" activates_default="true">
			<default>192.168.1.2</default>
			<variable>ipaddress</variable>
		</entry>
	</hbox>
	<hbox>
		<text><label>Network Mask:	</label></text>
		<entry editable="true" activates_default="true">
			<default>255.255.255.0</default>
			<variable>netmask</variable>
		</entry>
	</hbox>
	<hbox>
		<text><label>Gateway:		</label></text>
		<entry editable="true" activates_default="true">
			<default>192.168.1.1</default>
			<variable>gateway</variable>
		</entry>
	</hbox>
	<hbox>
		<text><label>DNS Server 1:		</label></text>
		<entry editable="true" activates_default="true">
			<default>8.8.8.8</default>
			<variable>dns1</variable>
		</entry>
	</hbox>
	<hbox>
		<text><label>DNS Server 2:		</label></text>
		<entry editable="true" activates_default="true">
			<default>208.67.222.222</default>
			<variable>dns2</variable>
		</entry>
	</hbox>
</vbox>



## ==================== WIRELESS PASSWORD 4 ==================== ##
<vbox  margin="5">
	<text use-markup="true" yalign="1"><label>"<span weight='"'bold'"' size='"'x-large'"'>Wireless Connection Details</span>"</label></text>
	<hseparator></hseparator>
        <hbox>
                <text width-request="570"><label>Wait for scan to finish and select an access point</label></text>
        </hbox>
	<comboboxtext file-monitor="'${TMP}'/essid" auto-refresh="true">
		<input file>'${TMP}'/essid</input>
		<variable>essid</variable>
	</comboboxtext>
	<expander expanded="false" tooltip-text="Click here to enter your hidden access point">
		<entry>
			<variable>hessid</variable>
			<action signal="changed">echo hidden_ssid_name=$hessid > $TMP/hessid.tmp</action>
		</entry>
		<label>Enter hidden access point</label>
		<variable>expander1</variable>
	</expander>
	<text><label>""</label></text>
	<hseparator></hseparator>
	<comboboxtext>
		<item>Encryption type ( Default is: open network )</item>
		<item>WEP</item>
		<item>WPA/WPA2 Personal</item>
		<item>WPA/WPA2 Enterprise (PEAP)</item>
		<variable>enctype</variable>
		<action signal="changed">echo $enctype | grep -q WEP && enctype=wep && encpass=wep_key; echo $enctype | grep -q Personal && enctype=wpa && encpass=wpa_password; echo $enctype | grep -q PEAP && enctype=eap-peap && encpass=peap_password; echo wifi_encryption=$enctype > $TMP/encryption.tmp; echo $encpass > $TMP/enc-pass</action>
		<action condition="command_is_true( [ `egrep -c '"'wep|wpa'"' $TMP/encryption.tmp` = 1 ] && echo true )" function="enable">p1</action>
		<action condition="command_is_true( [ `egrep -c '"'wep|wpa'"' $TMP/encryption.tmp` = 1 ] && echo true )" function="enable">PassKey</action>
		<action condition="command_is_true( [ `egrep -c '"'wep|wpa'"' $TMP/encryption.tmp` = 1 ] && echo true )">rm -f $TMP/peap-username.tmp</action>
		<action condition="command_is_true( [ `grep -c eap-peap $TMP/encryption.tmp` = 1 ] && echo true )" function="enable">p2</action>
		<action condition="command_is_true( [ `grep -c eap-peap $TMP/encryption.tmp` = 1 ] && echo true )" function="enable">Username</action>
		<action condition="command_is_true( [ `grep -c eap-peap $TMP/encryption.tmp` = 1 ] && echo true )" function="enable">p1</action>
		<action condition="command_is_true( [ `grep -c eap-peap $TMP/encryption.tmp` = 1 ] && echo true )" function="enable">PassKey</action>
		<action condition="command_is_true( [ `grep -c eap-peap $TMP/encryption.tmp` = 0 ] && echo true )" function="disable">p2</action>
		<action condition="command_is_true( [ `grep -c eap-peap $TMP/encryption.tmp` = 0 ] && echo true )" function="disable">Username</action>
		<action condition="command_is_true( [ `egrep -c '"'wep|wpa|eap-peap'"' $TMP/encryption.tmp` = 0 ] && echo true )" function="disable">p1</action>
		<action condition="command_is_true( [ `egrep -c '"'wep|wpa|eap-peap'"' $TMP/encryption.tmp` = 0 ] && echo true )" function="disable">PassKey</action>
		<action condition="command_is_true( [ `egrep -c '"'wep|wpa|eap-peap'"' $TMP/encryption.tmp` = 0 ] && echo true )">rm -f $TMP/encryption.tmp $TMP/peap-username.tmp $TMP/fkey.tmp</action>
	</comboboxtext>
	<hbox>
		<text visibility="true" sensitive="false">
		    <variable>Username</variable>
		    <label>Username:		</label>
		</text>
		<entry visibility="true" sensitive="false" editable="true" activates_default="true">
		<variable>p2</variable>
		<action signal="changed">echo "peap_username=$p2" > $TMP/peap-username.tmp</action>
		</entry>
	</hbox>
	<hbox>
		<text visibility="true" sensitive="false">
		    <variable>PassKey</variable>
		    <label>Password/Key:		</label>
		</text>
		<entry visibility="true" sensitive="false" editable="true" activates_default="true">
		<variable>p1</variable>
		<action signal="changed">echo `cat $TMP/enc-pass`=$p1 > $TMP/fkey.tmp</action>
		</entry>
	</hbox>
	<hseparator></hseparator>
	<text><label>""</label></text>
        <hbox>
                <text width-request="570"><label>MAC address of the wifi card:		'`cat /sys/class/net/$(iwconfig | cut -d" " -f1 | sed '/^$/d' | sort | head -n1)/address | tr [a-z] [A-Z]`'</label></text>
        </hbox>
	<text><label>""</label></text>
        <hbox>
                <text width-request="570"><label>Please set the system clock if you experience connection troubles</label></text>
        </hbox>
	<text><label>""</label></text>
</vbox>



## ====================== PROXY SETTINGS 5 ====================== ##
<vbox>
	<text use-markup="true" yalign="1"><label>"<span weight='"'bold'"' size='"'x-large'"'>Proxy Settings</span>"</label></text>
	<hseparator></hseparator>
	<text use-markup="true" xalign="0"><label>"<span weight='"'bold'"'>1. Click Next if you are not using proxy</span>"</label></text>
	<text><label>""</label></text>
	<text use-markup="true" xalign="0"><label>"<span weight='"'bold'"'>2. Manual configuration</span>"</label></text>
	<text yalign="0" xalign="0" wrap="true" width-request="'${TXTWIDTH}'">
		<label>If you are behind a proxy then please enter the proxy details in the input field below in following format: ipaddress:port. For password protected proxies enter: username:password@ipaddress:port</label>
	</text>
	<entry editable="true" activates_default="true">
		<variable>proxy</variable>
		<default>guest:secret@192.168.1.20:3128</default>
		<action signal="changed" function="disable">proxypac</action>
		<action signal="changed" function="enable">proxyExcEn</action>
		<action signal="changed" function="enable">proxyExcDis</action>
		<action signal="changed">echo proxy=$proxy > $TMP/proxy.tmp</action>
	</entry>
	<hbox>
	<text><label>Proxy exceptions:</label></text>
	<hbox width-request="135"><text><label>""</label></text></hbox>
	<hbox>
	<radiobutton tooltip-text="All traffic must go through proxy" file-monitor="true" auto-refresh="true">
		<label>No</label>
		<variable>proxyExcDis</variable>
		<default>true</default>
		<input file>'${TMP}'/proxyExcDis.mon</input>
		<action>if true rm -f $TMP/proxy-exceptions.tmp</action>
		<action>if true disable:proxyExcList</action>
	</radiobutton>
	<radiobutton tooltip-text="Allow proxy exceptions">
		<label>Yes</label>
		<variable>proxyExcEn</variable>
		<default>false</default>
		<action>if true enable:proxyExcList</action>
		<action>echo "proxy_exceptions=$proxyExcList" > $TMP/proxy-exceptions.tmp</action>
	</radiobutton>
	</hbox>
	<hbox width-request="214"><text><label>""</label></text></hbox>
	</hbox>
	<hbox>
	<text><label>No proxy for:</label></text>
	<entry sensitive="false">
	<variable>proxyExcList</variable>
	<default>127.0.0.1 domain.local</default>
	<action signal="changed">echo "proxy_exceptions=$proxyExcList" > $TMP/proxy-exceptions.tmp</action>
	</entry>
	</hbox>
	<text><label>""</label></text>
	<text use-markup="true" xalign="0"><label>"<span weight='"'bold'"'>3. Automatic configuration</span>"</label></text>
	<text yalign="0" xalign="0" wrap="true" width-request="'${TXTWIDTH}'">
		<label>Provide an URL to a file with automatic proxy configuration:</label>
	</text>
	<entry editable="true" activates_default="true">
		<variable>proxypac</variable>
		<default>http://domain.com/files/proxy.pac</default>
		<action signal="changed" function="disable">proxy</action>
		<action signal="changed" function="disable">proxyExcEn</action>
		<action signal="changed" function="disable">proxyExcDis</action>
		<action signal="changed" function="disable">proxyExcList</action>
		<action signal="changed">echo true > '${TMP}'/proxyExcDis.mon</action>
		<action signal="changed">echo proxy_config=$proxypac > $TMP/proxy.tmp</action>
	</entry>
	<text><label>""</label></text>
</vbox>


## ======================= FINAL REPORT 7 ======================= ##
<vbox>
	<text use-markup="true" yalign="1"><label>"<span weight='"'bold'"' size='"'x-large'"'>Confirmation</span>"</label></text>
	<hseparator></hseparator>
	<text><label>""</label></text>
	<text yalign="0" xalign="0" wrap="true" width-request="'${TXTWIDTH}'">
		<label>Please wait for the settings to appear below. Confirm that these settings are correct and then click the next button. Click restart to begin again and make changes.</label>
	</text>
	<text><label>""</label></text>
	<text yalign="0" xalign="0" wrap="true" width-request="'${TXTWIDTH}'" file-monitor="true" auto-refresh="true">
		<label>Your final report</label>
		<variable>txtReport</variable>
		<input file>/tmp/report</input>
	</text>
</vbox>



<variable>nPage</variable>
<input file>'${TMP}'/.knetPage</input>
</notebook>

## ==================== BACK/NEXT BUTTONS ==================== ##
<hbox>
    <button visible="true" tooltip-text="Abort">
		<label>Abort</label>
		<variable>butAbort</variable>
		<input file>'${BUTPREV}'</input>
		<width>16</width>
		<action>echo "true" > /tmp/net-abort</action>
	    <action function="exit">finished</action>
	</button>
	<button visible="false" sensitive="false">
		<label>Restart</label>
		<variable>butBack</variable>
		<input file>'${BUTPREV}'</input>
		<action function="disable">butBack</action>
		<action>echo 0 > $TMP/.knetPage</action>
		<action>rm -f '${REPORT}' '${TMP}'/encryption.tmp '${TMP}'/authtype.tmp</action>
		<action>touch '${REPORT}' '${TMP}'/encryption.tmp '${TMP}'/authtype.tmp</action>
		<action function="clear">hessid</action>
		<action function="clear">p1</action>
		<action function="clear">p2</action>
		<action function="clear">a1</action>
		<action function="clear">a2</action>
		<action function="refresh">authtype</action>
		<action function="refresh">enctype</action>
		<action function="disable">butForth</action>
		<action function="hide">butSetClock</action>
		<action function="hide">butScanWifi</action>
		<action>rm '${TMP}'/*.tmp 2>/dev/null</action>
		<action>rm '${CONF}' 2>/dev/null</action>
		<action function="show">butKbdLayout</action>
		<action function="show">butAbort</action>
		<action function="hide">butBack</action>
		<action function="refresh">nPage</action>
	</button>
	<button visible="true" tooltip-text="Set custom keyboard layout">
		<label>Set keyboard layout</label>
		<variable>butKbdLayout</variable>
		<input file>/usr/share/pixmaps/vk-48.png</input>
		<width>16</width>
		<action>/opt/scripts/set-kbd-layout &</action>
	</button>
	<button tooltip-text="Launch virtual keyboard">
	    <label>Virtual keyboard</label>
	    <input file>/usr/share/pixmaps/vk-48.png</input>
	    <variable>butVKeyboard</variable>
	    <width>16</width>
	    <action>pidof xvkbd && killall xvkbd || /opt/scripts/xvkbd</action>
	</button>
	<button visible="false" tooltip-text="Launch timeconfig utility">
		<label>Set clock</label>
		<variable>butSetClock</variable>
		<input file>/usr/share/pixmaps/clock-48.png</input>
		<width>16</width>
		<action>/opt/scripts/set-system-clock &</action>
	</button>
	<button visible="false" tooltip-text="Repeat scanning if your AP is not found">
		<label>Re-scan wifi</label>
		<variable>butScanWifi</variable>
		<input file>/usr/share/pixmaps/idle-48.png</input>
		<width>16</width>
		<action>get_essid</action>
	</button>
	<button sensitive="false" can-default="true" has-default="true">
		<label>Next</label>
		<variable>butForth</variable>
		<input file>'${BUTNEXT}'</input>

		<action condition="command_is_true( [ `cat $TMP/.knetPage` -eq 6 ] && echo true )">EXIT:finished</action>
		<action condition="command_is_true( [ `cat $TMP/.knetPage` -eq 5 ] && echo true )">get_report</action>
		<action condition="command_is_true( [ `cat $TMP/.knetPage` -eq 5 ] && echo true )">enable:butForth</action>
		<action condition="command_is_true( [ `cat $TMP/.knetPage` -eq 5 ] && echo true )">echo 6 > $TMP/.knetPage</action>
		<action condition="command_is_true( [ `cat $TMP/.knetPage` -eq 4 ] && echo true )">hide:butSetClock</action>
		<action condition="command_is_true( [ `cat $TMP/.knetPage` -eq 4 ] && echo true )">hide:butScanWifi</action>
		<action condition="command_is_true( [ `grep wifi $TMP/connection.tmp` ] && [ `cat $TMP/.knetPage` -eq 4 ] && [ ! -f $TMP/hessid.tmp ] && echo true )">echo ssid_name=`echo $essid | cut -d\" -f2` > $TMP/essid.tmp</action>
		<action condition="command_is_true( [ `cat $TMP/.knetPage` -eq 4 ] && echo true )">get_report</action>
		<action condition="command_is_true( [ `cat $TMP/.knetPage` -eq 4 ] && echo true )">echo 6 > $TMP/.knetPage</action>
		<action condition="command_is_true( [ `cat $TMP/.knetPage` -eq 3 ] && echo true )">manual_settings</action>
		<action condition="command_is_true( [ `grep wired $TMP/connection.tmp` ] && [ `cat $TMP/.knetPage` -eq 3 ] && echo true )">get_report</action>
		<action condition="command_is_true( [ `grep wired $TMP/connection.tmp` ] && [ `cat $TMP/.knetPage` -eq 3 ] && echo true )">echo 6 > $TMP/.knetPage</action>
		<action condition="command_is_true( [ `grep wifi $TMP/connection.tmp` ] && [ `cat $TMP/.knetPage` -eq 3 ] && echo true )">show:butSetClock</action>
		<action condition="command_is_true( [ `grep wifi $TMP/connection.tmp` ] && [ `cat $TMP/.knetPage` -eq 3 ] && echo true )">show:butScanWifi</action>
		<action condition="command_is_true( [ `grep wifi $TMP/connection.tmp` ] && [ `cat $TMP/.knetPage` -eq 3 ] && echo true )">echo 4 > $TMP/.knetPage</action>
		<action condition="command_is_true( [ `cat $TMP/.knetPage` -eq 1 ] && echo true )">dialup_settings</action>
		<action condition="command_is_true( [ `cat $TMP/.knetPage` -eq 1 ] && echo true )">disable:butForth</action>
		<action condition="command_is_true( [ `cat $TMP/.knetPage` -eq 1 ] && echo true )">echo 6 > $TMP/.knetPage</action>
		<action>go_forward</action>
		<action function="enable">proxy</action>
		<action function="enable">proxypac</action>
		<action function="enable">butBack</action>
		<action function="refresh">nPage</action>
	</button>
	<button visible="false">
		<label>Finish</label>
		<variable>butFinish</variable>
		<input file>'${BUTNEXT}'</input>
	</button>
</hbox>

</vbox>
</window>'

## Remove any comments and launch first window
SPATH=${SCRIPT%/*}
echo "$WIZARD_PRE"| sed '/^##/d' | gtkdialog -i /opt/setup/wizards/inc/wizard-functions -s -c > ${TMP}/output

[ -f /tmp/net-abort ] || {
    ## Create a /tmp/config
    cp -a /tmp/report /tmp/config
    . genconfig.sh ${NEO_CFG_ROOT}
    . genconfig.sh ${NEO_CFG_ROOT_VAR}
}

cleanup
