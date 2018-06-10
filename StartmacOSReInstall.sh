#!/bin/sh
# ReInstalls macOS using a pre-deployed application path
#   Version: 1.0
#   Author: Ryan Powell
#   Reference: https://github.com/rypowell1988/mac-management/blob/master/UserTemplateConfig.sh
#   Note: This script uses:
#       Parameter 4 in the JSS to define if the FS should be wiped (yes - default is no)
#       Parameter 5 in the JSS to define if the FS should be converted to APFS (yes - default is no)
#       Parameter 6 in the JSS to define the reboot delay in seconds


# THE INITIAL COMMAND PARAMETERS
commandParams="--agreetolicense"


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
   fi;


# EXECUTE THE COMMAND
   sudo "/Applications/Install macOS High Sierra.app/Contents/Resources/startosinstall" "commandParams" &


exit 0
