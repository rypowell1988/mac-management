#!/bin/sh
# macOS DEPNotify Configuration Script
#   Version: 1.0
#   Author: Ryan Powell
#   Reference: https://github.com/rypowell1988/mac-management/PostDEPSetup.sh


# CREATE LOG FILE
   logDir="/Library/University of Derby/Logs"
   if [[ ! -d "$logDir" ]]; then 
      sudo mkdir -p "$logDir"
   fi
   logFile="$logDir/PostDEPSetup.txt"
   if [[ -f "$logFile" ]]; then
      rm "$logFile"
   fi
   sudo chmod -R 777 "$logDir"
   sudo echo "Log Started" >> $logFile
   sudo chown root:wheel "$logFile"
   sudo chmod 777 "$logFile"


# WAIT FOR THE DOCK PROCESS TO HAVE STARTED - INDICATING THE USER SESSION HAS FULLY STARTED
   count=0
   dock_status=""
   echo "Waiting for Dock" >> $logFile
   while [[ "$dock_status" == "" ]]; do
      count=$((++count))
      echo "Try $count of a max of 10" >> $logFile
      sleep 5
      dock_status=$(pgrep -x Dock)
      if [[ $count == 10 ]]; then
         echo "Dock timeout reached" >> $logFile
         exit 2
      fi
   done
   echo "Dock process is now running" >> $logFile


# BLOCK THE DESKTOP
   /Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType fs  -icon /private/var/tmp/CasperImaging.png -description "Setup will continue shortly" -heading "Preparing first run script..." -fullScreenLogo -launchd &


# CHECK THE JAMF BINARY EXISTS
   echo "Checking Jamf Exists" >> $logFile
   if [[ ! -f /usr/local/jamf/bin/jamf ]]; then
      echo "Jamf Binary not found" >> $logFile
      exit 1
   fi


# CALL THE DEPNOTIFY POLICY FROM JAMF
   echo "Calling DEPNotify Policy" >> $logFile
   sudo /usr/local/jamf/bin/jamf policy -trigger policy_depnotify >> $logFile

    
# EXIT SUCCESSFUL
   exit 0
