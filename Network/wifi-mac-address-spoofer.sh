#!/bin/bash

#
# Spoof the MAC address for your wi-fi connection.
#
# <bitbar.title>Wi-Fi MAC Address Spoofer</bitbar.title>
# <bitbar.version>1.0.0</bitbar.version>
# <bitbar.author>Luis Cruz</bitbar.author>
# <bitbar.author.github>sprak3000</bitbar.author.github>
# <bitbar.desc>Spoof the MAC address for your wi-fi connection.</bitbar.desc>
# <bitbar.image>https://sprak3000.github.io/assets/images/blog/zooms-today.png</bitbar.image>
# <bitbar.dependencies>icalBuddy</bitbar.dependencies>
#
# Based off of the "Change your MAC address with a shell script" article by Josh Thompson:
#   https://josh.works/shell-script-basics-change-mac-address
#

statusBarIcon=":japanese_goblin:"

# Hat tip to lac_dev in https://stackoverflow.com/a/57329110
wiFiDetails=$(networksetup -listallhardwareports | grep Wi-Fi -A 3)
wiFiDevice=$(echo "${wiFiDetails}" | awk '/Device:/{print $2}')
originalAddr=$(echo "${wiFiDetails}" | awk '/Ethernet Address:/{print $3}')

spoof_mac_address() {
  # Hat tip to miken32 in https://stackoverflow.com/a/42661696
  spoofAddress=$(hexdump -n 6 -ve '1/1 "%.2x "' /dev/random | awk -v a="2,6,a,e" -v r="$RANDOM" 'BEGIN{srand(r);}NR==1{split(a,b,",");r=int(rand()*4+1);printf "%s%s:%s:%s:%s:%s:%s\n",substr($1,0,1),b[r],$2,$3,$4,$5,$6}')
  echo "Spoof Address: ${spoofAddress}"
}

echo "${statusBarIcon}"
echo "---"
echo "Wi-fi Device: ${wiFiDevice}"
echo "Wi-fi MAC Address at start: ${originalAddr}"
echo "Generate spoofed MAC address | bash=$0 param1=spoof terminal=false refresh=true"
echo "Param?: ${1}"

if [ "${1}" = "spoof" ]; then
  spoof_mac_address
fi

#echo "Current MAC Address: ${spoofMACAddress}"

# sudo ifconfig "${wiFiDevice}" ether "${spoofMACAddress}"
