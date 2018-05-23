#!/bin/sh
# Copies a directory of screensaver images from an SMB directory locally and sets this as the path for screensaver images
#   Version: 1.0
#   Author: Ryan Powell
#   Reference: https://github.com/rypowell1988/mac-management/blob/master/CopyAndSetScreensaver.sh
#   Note: This script uses:
#            Parameter 4 in the JSS to define the network domain netbios name         
#            Parameter 5 in the JSS to define the network domain name
#            Parameter 6 in the JSS to define the SMB path of images
#            Parameter 7 in the JSS to define the local path to store screensaver images
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
ping -c 3 -i 3 -o "$5" > /dev/null
if [[ $? > 0 ]]; then
   echo "Unable to contact the university network"
   exit 1
fi


# Some Variables
loggedInUser=$(stat -f%Su /dev/console)
mntLocal="/private/tmp/scr"
macUUID=`ioreg -rd1 -c IOPlatformExpertDevice | grep -i "UUID" | cut -c27-62`


# Check we're not already mounted
currentMount=`mount | grep "$mntLocal"`
if [[ ! $currentMount == '' ]]; then
    echo "Unmounting previous mount point"
    sudo diskutil unmount force $mntLocal
    sleep 2
fi


# Create Mount
if [[ ! -d "$mntLocal" ]]; then
   mkdir -p "$mntLocal"
fi
sudo mount_smbfs "//$4;$8:$9@$6" "$mntLocal" > /dev/null
if [[ $? > 0 ]]; then
   echo "Unable to connect to the university DFS shares"
   exit 2
fi
sleep 1


# Check if the screensaver directory exists and create it if not
if [[ ! -d "$7" ]]; then
   sudo mkdir -p "$7"
fi


# Copy images and remove the thumbs.db file
sudo rm -f "$7"/*
sudo cp "$mntLocal"/* "$7"
sudo rm -f "$7/Thumbs.db"
sleep 1
# Remove the Mount
sudo diskutil unmount force $mntLocal
sleep 1
sudo rm -d -f "$mntLocal"


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
defaults write "/Users/$loggedInUser/Library/Preferences/ByHost/com.apple.screensaverphotochooser.$macUUID.plist" LastViewedPhotoPath "$7"
defaults write "/Users/$loggedInUser/Library/Preferences/ByHost/com.apple.ScreenSaver.iLifeSlideshows.$macUUID.plist" styleKey "Classic"
chown $loggedInUser "/Users/$loggedInUser/Library/Preferences/ByHost/com.apple.screensaver.$macUUID.plist"
chown $loggedInUser "/Users/$loggedInUser/Library/Preferences/ByHost/com.apple.screensaverphotochooser.$macUUID.plist"
chown $loggedInUser "/Users/$loggedInUser/Library/Preferences/ByHost/com.apple.screensaverphotochooser.$macUUID.plist"
killall cfprefsd

exit 0
