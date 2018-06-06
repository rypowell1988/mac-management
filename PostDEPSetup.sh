#!/bin/sh
# macOS DEPNotify Configuration Script
#   Version: 1.0
#   Author: Ryan Powell
#   Reference: https://github.com/rypowell1988/mac-management/PostDEPSetup.sh


# WAIT FOR THE DOCK PROCESS TO HAVE STARTED - INDICATING THE USER SESSION HAS FULLY STARTED
    count=0
    dock_status=$(pgrep -x Dock)
    echo "Waiting for Dock"
    while [[ "$dock_status" == "" ]]; do
        count=$((++count))
        sleep 5
        dock_status=$(pgrep -x Dock)
        if [[ $count == 10 ]]; then
          exit 2
        fi
    done


# CHECK THE JAMF BINARY EXISTS
    echo "Checking Jamf Exists"
    if [[ ! -f /usr/local/jamf/bin/jamf ]]; then
        exit 1
    fi


# CALL THE DEPNOTIFY POLICY FROM JAMF
    echo "Calling DEPNotify Policy"
    sudo /usr/local/jamf/bin/jamf policy -trigger policy_depnotify
    
exit 0
