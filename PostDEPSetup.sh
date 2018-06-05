#!/bin/sh
# macOS DEPNotify Configuration Script
#   Version: 1.0
#   Author: Ryan Powell
#   Reference: https://github.com/rypowell1988/mac-management/PostDEPSetup.sh


# WAIT FOR THE DOCK PROCESS TO HAVE STARTED - INDICATING THE USER SESSION HAS FULLY STARTED
    dock_status=$(pgrep -x Dock)
    while [[ "$dock_status" == "" ]]; do
        echo "Waiting for Dock" >> $depnLog
        sleep 5
        dock_status=$(pgrep -x Dock)
    done


# CHECK THE JAMF BINARY EXISTS
    if [[ ! -f /usr/local/jamf/bin/jamf ]]; then
        exit 1
    fi


# CALL THE DEPNOTIFY POLICY FROM JAMF
    sudo /usr/local/jamf/bin/jamf policy -trigger policy_depnotify &
    
Exit 0
