#!/bin/sh
# Copies a directory of screensaver images from an SMB directory locally and sets this as the path for screensaver images
#   Version: 1.0
#   Author: Ryan Powell
#   Reference: https://github.com/rypowell1988/mac-management/blob/master/CopyAndSetScreensaver.sh
#   Note: This script uses:
#            Parameter 4 in the JSS to define the network domain name
#            Parameter 5 in the JSS to define the SMB path of images
#            Parameter 6 in the JSS to define the local path to store screensaver images
#            Parameter 7 in the JSS to define a display name for the Screensaver path used in preferences
#            Parameter 8 in the JSS to define the username to connect to the SMB share with
#            Parameter 9 in the JSS to define the password to connect tot he SMB share with

# Check Parameters have been passed
if [[ $4 == "" ]]; then
    exit 1
fi
if [[ $5 == "" ]]; then
    exit 1
fi
if [[ $6 == "" ]]; then
    exit 1
fi
if [[ $7 == "" ]]; then
    exit 1
fi
if [[ $8 == "" ]]; then
    exit 1
fi
if [[ $9 == "" ]]; then
    exit 1
fi


# Test if we're connected to the network
ping -c 3 -i 3 -o "$4" > /dev/null
if [[ $? > 0 ]]; then
   echo "Unable to contact the university network"
   exit 1
fi

# Some Variables
loggedInUser=$(stat -f%Su /dev/console)
mntLocal="/tmp/scr"
macUUID=`ioreg -rd1 -c IOPlatformExpertDevice | grep -i "UUID" | cut -c27-62`

echo "Current user: $loggedInUser"


# Check we're not already mounted
currentMount=`mount | grep "$mntLocal"`
if [[ ! $currentMount == '' ]]; then
   umount $mntLocal -f
fi

# Create Mount
if [[ ! -d "$mntLocal" ]]; then
   mkdir -p "$mntLocal"
fi
mount_smbfs "//$4;$8:$9@$5" "$mntLocal" > /dev/null
if [[ $? > 0 ]]; then
   echo "Unable to connect to the university DFS shares"
   exit 2
fi

# Check if the screensaver directory exists and create it if not
if [[ ! -d "$6" ]]; then
   sudo mkdir -p "$6"
fi

# Copy images and remove the thumbs.db file
sudo rm "$6"/*
sudo cp "$6"/* "$6"
sudo rm "$6/Thumbs.db"

# Remove the Mount
umount "$mntLocal" -f
sudo rmdir "$mntLocal"

# Set the Screensaver for the current user
defaults write "/Users/$loggedInUser/Library/Preferences/ByHost/com.apple.screensaver.$macUUID.plist" moduleDict -dict-add moduleName iLifeSlideshows
defaults write "/Users/$loggedInUser/Library/Preferences/ByHost/com.apple.screensaver.$macUUID.plist" moduleDict -dict-add path /System/Library/Frameworks/ScreenSaver.framework/Resources/iLifeSlideshows.saver
defaults write "/Users/$loggedInUser/Library/Preferences/ByHost/com.apple.screensaver.$macUUID.plist" moduleDict -dict-add type 0
defaults write "/Users/$loggedInUser/Library/Preferences/ByHost/com.apple.screensaver.$macUUID.plist" idleTime -int 600
defaults write "/Users/$loggedInUser/Library/Preferences/ByHost/com.apple.screensaverphotochooser.$macUUID.plist" CustomFolderDict -dict-add identifier "$7"
defaults write "/Users/$loggedInUser/Library/Preferences/ByHost/com.apple.screensaverphotochooser.$macUUID.plist" CustomFolderDict -dict-add name UoD
defaults write "/Users/$loggedInUser/Library/Preferences/ByHost/com.apple.screensaverphotochooser.$macUUID.plist" SelectedSource -int 4
defaults write "/Users/$loggedInUser/Library/Preferences/ByHost/com.apple.screensaverphotochooser.$macUUID.plist" ShufflesPhotos -int 1
defaults write "/Users/$loggedInUser/Library/Preferences/ByHost/com.apple.screensaverphotochooser.$macUUID.plist" SelectedFolderPath "$7"
defaults write "/Users/$loggedInUser/Library/Preferences/ByHost/com.apple.screensaverphotochooser.$macUUID.plist" LastViewedPhotoPath
defaults write "/Users/$loggedInUser/Library/Preferences/ByHost/com.apple.ScreenSaver.iLifeSlideshows.$macUUID.plist" styleKey "Classic"
chown $loggedInUser "/Users/$loggedInUser/Library/Preferences/ByHost/com.apple.screensaver.$macUUID.plist"
chown $loggedInUser "/Users/$loggedInUser/Library/Preferences/ByHost/com.apple.screensaverphotochooser.$macUUID.plist"
chown $loggedInUser "/Users/$loggedInUser/Library/Preferences/ByHost/com.apple.screensaverphotochooser.$macUUID.plist"
killall cfprefsd

exit 0
