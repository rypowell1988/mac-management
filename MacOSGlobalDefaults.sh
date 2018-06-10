#!/bin/sh
# macOS First Run Script to Configure Global Defaults
#   Version: 1.0
#   Author: Ryan Powell
#   Reference: https://github.com/rypowell1988/mac-management/blob/master/MacOSGlobalDefaults.sh
#   Note: This script uses parameter 4 in the JSS to define the NTP Server


# CHECK PARAMETERS HAVE BEEN PASSED
   if [[ $4 == "" ]]; then
       exit 1
   fi

# SET CURRENT TIMEZONE
   /usr/sbin/systemsetup -settimezone "Europe/London"


# SET REGION AND LOCALE
   /usr/bin/defaults write /Library/Preferences/.GlobalPreferences AppleLocale en_GB
   /usr/bin/defaults write /Library/Preferences/.GlobalPreferences Country GB
   /usr/bin/defaults write /Library/Preferences/.GlobalPreferences AppleMeasurementUnits -string "Centimeters"
   /usr/bin/defaults write /Library/Preferences/.GlobalPreferences AppleMetricUnits -bool true


# ENABLE NETWORK TIME SERVER
   /usr/sbin/systemsetup -setusingnetworktime on


# SET NETWORK TIME SERVER
   /usr/bin/systemsetup -setnetworktimeserver "$4"


# DISABLE TIME MACHINE POPUP FOR EXTERNAL DRIVES
   /usr/bin/defaults write /Library/Preferences/com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true


# HIDE MANAGEMENT ACCOUNTS FROM THE LOGIN WINDOW
   /usr/bin/defaults write /Library/Preferences/com.apple.loginwindow Hide500Users -bool true


exit 0
