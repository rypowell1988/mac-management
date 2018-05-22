#!/bin/sh
# Configures all default user templates to enable certain settings for newly created users
#   Version: 1.0
#   Author: Ryan Powell
#   Reference: 


# Determine OS version
os_vers=$(sw_vers -productVersion)
os_build=$(sw_vers -buildVersion)


# User template defaults
for USER_TEMPLATE in "/System/Library/User Template"/*
	do
	  # Disable first login prompts for Siri, iCloud, Gestures and Diagnostics
		/usr/bin/defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.SetupAssistant DidSeeSiriSetup -bool TRUE
		/usr/bin/defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.SetupAssistant DidSeeSyncSetup -bool TRUE
		/usr/bin/defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.SetupAssistant DidSeeSyncSetup2 -bool TRUE
		/usr/bin/defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.SetupAssistant DidSeeCloudSetup -bool TRUE
		/usr/bin/defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.SetupAssistant DidSeeiCloudLoginForStorageServices -bool TRUE
		/usr/bin/defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.SetupAssistant DidSeeTouchIDSetup -bool TRUE
		/usr/bin/defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.SetupAssistant GestureMovieSeen none
		/usr/bin/defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.SetupAssistant LastSeenCloudProductVersion "${os_vers}"
		
		# Enable right click
		/usr/bin/defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.driver.AppleHIDMouse Button2 -int 2
		/usr/bin/defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.driver.AppleBluetoothMultitouch.mouse MouseButtonMode -string TwoButton
		/usr/bin/defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -int 1
		
		# Default to search current directory
		/usr/bin/defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.finder FXDefaultSearchScope -string "SCcf"
		
		# Avoid creating .DS_Store files on network or USB volumes
    /usr/bin/defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.desktopservices DSDontWriteNetworkStores -bool true
    /usr/bin/defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.desktopservices DSDontWriteUSBStores -bool true
		
		# Minimise into Dock App Icon
		/usr/bin/defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.dock minimize-to-application -bool true
		
		# default Safari homepage
		/usr/bin/defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.Safari HomePage -string "https://www.derby.ac.uk"
		
	done
	
exit 0
