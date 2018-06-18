#!/bin/sh
# ReInstalls macOS using a pre-deployed application path
#   Version: 1.0
#   Author: Ryan Powell
#   Reference: https://github.com/rypowell1988/mac-management/blob/master/StartmacOSReInstall.sh
#   Note: This script uses:
#       Parameter 4 in the JSS to define if the FS should be wiped (yes - default is no)
#       Parameter 5 in the JSS to define if the FS should be converted to APFS (yes - default is no)
#       Parameter 6 in the JSS to define the reboot delay in seconds


# THE INITIAL COMMAND PARAMETERS
   commandParams="--nointeraction --agreetolicense"


# CHECK IF ERASING THE FS
   if [[ $4 == "yes" ]]; then
      commandParams="$commandParams --eraseinstall"
   fi


# CHECK IF CONVERTING THE FS
   if [[ $5 == "yes" ]]; then
      commandParams="$commandParams --converttoapfs YES"
   else
      commandParams="$commandParams --converttoapfs NO"
   fi


# CHECK AN INTEGER REBOOT DELAY IS SUPPLIED
   if [[ $6 =~ ^[0-9]+$ ]]; then
      commandParams="$commandParams --rebootdelay $6"
   fi


# EXECUTE THE COMMAND
   sudo /usr/local/jamf/bin/jamf policy -trigger pkg_uodjamfhelperbranding
   /Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType fs  -icon /Private/Var/tmp/CasperImaging.png -description "Setup will begin shortly" -heading "Preparing macOS Installer..." -fullScreenLogo -launchd &
   echo "Executing command: /Applications/Install macOS High Sierra.app/Contents/Resources/startosinstall $commandParams"
   sudo "/Applications/Install macOS High Sierra.app/Contents/Resources/startosinstall" $commandParams
   echo "Response code: $?"
   
   
# INSTALL SHOULD HAVE STARTED WITHIN 15 MINS, IF NOT REBOOT THE MAC SO USER CAN CONTINUE WORKING
   sudo shutdown -r +15 &


# Exit Successful
   exit 0
