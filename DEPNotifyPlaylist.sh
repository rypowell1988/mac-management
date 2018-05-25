#!/bin/sh
# Hard coded into the DEP Notify package to be executed.  This script is essentially our 'image'
#   Version: 1.0
#   Author: Ryan Powell
#   Reference: https://github.com/rypowell1988/mac-management/blob/master/DEPNotifyPlaylist.sh


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


# DEPLOYING UOD SCREENSAVER Images VIA JAMF POLICY TRIGGER
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

exit 0
