#!/bin/sh
# macOS DEPNotify Configuration Script
#   Version: 1.0
#   Author: Ryan Powell
#   Reference: https://github.com/rypowell1988/mac-management/blob/master/SetupDEPNotify.sh


# SETUP SOME VARIABLES
    depnDir="/var/tmp/DEPNotify"
    depnLog="$depnDir/DEPNotify.log"
    current_user=`id -un`
	

# WAIT FOR THE DOCK PROCESS TO HAVE STARTED - INDICATING THE USER SESSION HAS FULLY STARTED
    dock_status=$(pgrep -x Dock)
    while [[ "$dock_status" == "" ]]; do
        echo "Waiting for Dock" >> $depnLog
        sleep 5
        dock_status=$(pgrep -x Dock)
    done


# SETUP DEPNOTIFY.
    sudo "$depnDir/DEPNotify.app/Contents/MacOS/DEPNotify" -path $depnLog -fullScreen &
    echo "Command: Image: $depnDir/icon.png" >> $depnLog
    echo "Command: MainTitle: macOS Setup " >> $depnLog
    echo "Command: MainText: We're setting up your Mac.  This might take a while depending on your connection to the network and how much software or how many updates are required. " >> $depnLog


# LOOK FOR THE JAMF BINARY.
    echo "Status: Looking for Jamf..." >> $depnLog
    if [[ ! -f /usr/local/jamf/bin/jamf ]]; then
        echo "Command: Alert: Setup cannot continue because this Mac doesn't appear to be enrolled" >> $depnLog
        echo "Command: Quit" >> $depnLog
        rm $depnLog
        exit 1
    fi


# AS WE INITIALISE, DISABLE SLEEP AND SCHEDULED UPDATES
    echo "Status: Initialising..." >> $depnLog
    sudo softwareupdate --schedule off
    caffeinate -d -i -m -s -u &
    caffeinate_pid=$!


# EXECUTE THE DEP NOTIFY PLAYLIST VIA JAMF POLICY TRIGGER
    echo "Status: Gathering required settings..." >> $depnLog
    sudo /usr/local/jamf/bin/jamf policy -trigger script_depnotifyplaylist
    sleep 1


# FINISHING UP - RE-ENABLING SCHEDULED UPDATE CHECKS, KILL CAFFEINATE AND CLEAR THE DEPNOTIFY LOG
    echo "Status: Finishing Up..." >> $depnLog
    sudo softwareupdate --schedule on
    kill "$caffeinate_pid"
    echo "Command: Quit" >> $depnLog
    rm $depnLog

exit 0
