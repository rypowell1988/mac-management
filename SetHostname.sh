#!/bin/sh
# macOS First Run Script to Set the Hostname
#   Version: 1.0
#   Author: Ryan Powell
#   Reference: https://github.com/rypowell1988/mac-management/blob/master/SetHostname.sh


# VARIABLE TO HOLD THE GENERATED COMPUTER NAME
   mac_name=""


# GENERATE THE NAME
   # Get the Mac address from adapter en0
   en0Config=`ifconfig en0` > /dev/null 2>&1
   if [[ $? == 0 ]]; then
       mac_addr=`ifconfig en0 | awk '/ether/{print $2}'`
       mac_name=${mac_addr//':'/''}
   else
     # Grab the System Serial Number
       hw_info=`system_profiler SPHardwareDataType`
       hw_serial=`echo "${hw_info}" | grep -i "Serial Number (system):" | awk '{print $4}'`
       mac_name=$hw_serial
   fi


# CHECK A NAME WAS GENERATED AND IF SO, APPLY IT
   if [[ ! $mac_name == "" ]]; then
       /usr/sbin/scutil --set HostName ${mac_name} > /dev/null 2>&1
       /usr/sbin/scutil --set LocalHostName ${mac_name} > /dev/null 2>&1
       /usr/sbin/scutil --set ComputerName ${mac_name} > /dev/null 2>&1
       dscacheutil -flushcache > /dev/null 2>&1
   fi


exit 0
