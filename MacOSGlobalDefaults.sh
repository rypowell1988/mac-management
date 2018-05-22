#!/bin/sh
# macOS First Run Script to Configure Global Defaults
#   Version: 1.0
#   Author: Ryan Powell
#   Reference: https://www.jamf.com/jamf-nation/discussions/22946


# Set Time Zone
/usr/sbin/systemsetup -settimezone "Europe/London"

# Set Region and Locale
/usr/bin/defaults write /Library/Preferences/.GlobalPreferences AppleLocale en_GB
/usr/bin/defaults write /Library/Preferences/.GlobalPreferences Country GB
/usr/bin/defaults write /Library/Preferences/.GlobalPreferences AppleMeasurementUnits -string "Centimeters"
/usr/bin/defaults write /Library/Preferences/.GlobalPreferences AppleMetricUnits -bool true

# Set Network Time
/usr/sbin/systemsetup -setusingnetworktime on

# Set Time Server
/usr/bin/systemsetup -setnetworktimeserver "ntp1.derby.ac.uk"

# Disable Time Machine's pop-up message whenever an external drive is plugged in
/usr/bin/defaults write /Library/Preferences/com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Hide management accounts from the login screen
/usr/bin/defaults write /Library/Preferences/com.apple.loginwindow Hide500Users -bool true

exit 0
