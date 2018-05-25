#!/bin/sh
# macOS DEPNotify Configuration Script
#   Version: 1.0
#   Author: Ryan Powell
#   Reference: https://github.com/rypowell1988/mac-management/StartDEPNotify.sh


# SETUP SOME VARIABLES
    depnDir="/var/tmp/DEPNotify"
    depnLog="$depnDir/DEPNotify.log"
    current_user=`id -un`


# DOES DEP NOTIFY EXIST?
if [[ ! -d "$depnDir/DEPNotify.app" ]]; then
    exit 1
fi


# WAIT FOR THE DOCK PROCESS TO HAVE STARTED - INDICATING THE USER SESSION HAS FULLY STARTED
    dock_status=$(pgrep -x Dock)
    while [[ "$dock_status" == "" ]]; do
        echo "Waiting for Dock" >> $depnLog
        sleep 5
        dock_status=$(pgrep -x Dock)
    done


# SETUP DEPNOTIFY.
    sudo "$depnDir/DEPNotify.app/Contents/MacOS/DEPNotify" -path $depnLog -fullScreen &
    echo "Command: Image: $depnDir/DEPNotifyLogo.png" >> $depnLog
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


# CONFIGURE HOSTNAME VIA JAMF POLICY TRIGGER
    echo "Status: Setting Hostname..." >> $depnLog
    sudo /usr/local/jamf/bin/jamf policy -trigger script_sethostname
    sleep 1


# CONFIGURE GLOBAL DEFAULTS VIA JAMF POLICY TRIGGER
    echo "Status: Configuring defaults settings..." >> $depnLog
    sudo /usr/local/jamf/bin/jamf policy -trigger script_globaldefaults
    sleep 1


# CONFIGURE USER TEMPLATE DEFAULTS VIA JAMF POLICY TRIGGER
    echo "Status: Configuring user template default settings..." >> $depnLog
    sudo /usr/local/jamf/bin/jamf policy -trigger script_usertemplatedefaults
    sleep 1


# DEPLOYING TREND AV VIA JAMF POLICY TRIGGER
    echo "Status: Installing - Trend AntiVirus..." >> $depnLog
    sudo /usr/local/jamf/bin/jamf policy -trigger pkg_trendav
    sleep 1


# DEPLOYING AVECTO DEFENDPOINT VIA JAMF POLICY TRIGGER
    echo "Status: Installing - Avecto DefendPoint..." >> $depnLog
    sudo /usr/local/jamf/bin/jamf policy -trigger pkg_avecto
    sleep 1


# DEPLOYING NEXTHINK VIA JAMF POLICY TRIGGER
    echo "Status: Installing - Nexthink..." >> $depnLog
    sudo /usr/local/jamf/bin/jamf policy -trigger pkg_nexthink
    sleep 1


# DEPLOYING MICROSOFT OFFICE VIA JAMF POLICY TRIGGER
    echo "Status: Installing - Microsoft Office..." >> $depnLog
    sudo /usr/local/jamf/bin/jamf policy -trigger pkg_msoffice
    sleep 1


# DEPLOYING UOD WALLPAPER IMAGES VIA JAMF POLICY TRIGGER
    echo "Status: Installing - UoD Wallpaper..." >> $depnLog
    sudo /usr/local/jamf/bin/jamf policy -trigger pkg_uodwallpaper
    sleep 1


# DEPLOYING UOD SCREENSAVER IMAGES VIA JAMF POLICY TRIGGER
    echo "Status: Installing - UoD Screensaver..." >> $depnLog
    sudo /usr/local/jamf/bin/jamf policy -trigger pkg_uodscreensaver
    sleep 1


# DEPLOYING SELF SERVICE VIA JAMF POLICY TRIGGER
    echo "Status: Installing - Self Service App..." >> $depnLog
    sudo /usr/local/jamf/bin/jamf policy -trigger pkg_selfservice
    sleep 1


# CHECKING IN WITH JAMF
    echo "Status: Checking in with Jamf..." >> $depnLog
    sudo /usr/local/jamf/bin/jamf recon
    sleep 1


# FINISHING UP - RE-ENABLING SCHEDULED UPDATE CHECKS, KILL CAFFEINATE AND CLEAR THE DEPNOTIFY LOG
    echo "Status: Finishing Up..." >> $depnLog
    sudo softwareupdate --schedule on
    kill "$caffeinate_pid"
    echo "Command: Quit" >> $depnLog
    sudo rm -rf $depnDir


exit 0
