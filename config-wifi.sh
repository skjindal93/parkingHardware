#!/bin/bash
function wifi {
	echo "network={
	ssid=\"$1\"
	scan_ssid=1
	key_mgmt=WPA-EAP
	identity=\"$2\"
	password=\"$3\"
	eap=PEAP
	phase1="peaplabel=0"
	phase2="auth=MSCHAPV2"
	priority=1
}"
}


function staticIP {
	echo "auto wlan0
allow-hotplug wlan0
iface wlan0 inet static
	address $1
	netmask 255.255.255.0
	gateway 192.168.1.1
wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf
iface default inet manual
wireless-power off

auto lo
iface lo inet loopback

auto eth0
allow-hotplug eth0
iface eth0 inet dhcp"
}


echo "Enter R-pi Id:"
read id
echo "Enter IP address:"
read ip
echo "Enter WiFi SSID name:"
read ssid
echo "Enter WiFi Username:"
read username
echo "Enter WiFi password:"
read passwd

wifiDetails="$(wifi $ssid $username $passwd)"
echo "${wifiDetails}"

echo "Setting up wpa_suppliant config..."
echo "${wifiDetails}" >> /etc/wpa_supplicant/wpa_supplicant.conf

echo "Setting up interfaces file..."
ipDetails="$(staticIP $ip)"
echo "${ipDetails}" > /etc/network/interfaces

echo "Creating ~/id.txt file..."
echo $id > ~/id.txt
mac=$( cat /sys/class/net/wlan0/address )
echo "MAC address:""${mac}"
echo "Sending CURL...."
export http_proxy="proxy62.iitd.ernet.in:3128"
export https_proxy="proxy62.iitd.ernet.in:3128"
cmd="curl -s -X PUT -d id=$id -d mac="${mac}" -d ip=$ip 'http://api.greenboard.in/parking/updatePiIP/'"
output=$(eval $cmd)
echo $output
sleep 10
#reboot

