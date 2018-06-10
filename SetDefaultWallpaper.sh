#!/bin/sh
# Takes a template image and sets this as the default login wallpaper and default user wallpaper
#   Version: 1.0
#   Author: Ryan Powell
#   Reference: https://github.com/rypowell1988/mac-management/blob/master/SetDefaultWallpaper.sh


# VARIABLES TO PATHS TO CERTAIN IMAGES
   templateImg="/Library/University of Derby/Wallpapers/WideScreen.png"
   adminImg="/Library/Caches/com.apple.desktop.admin.png"
   hsImg="/Library/Desktop Pictures/High Sierra.jpg"


# CHECK THE TEMPLATE IMAGE EXISTS
   if [[ ! -f "$templateImg" ]]; then
      exit 1
   fi

# GET THE SCREEN RESOLUTION
   screenres=`system_profiler SPDisplaysDataType | grep Resolution`
   resW=$(echo $screenres | awk '{print $2}')
   resH=$(echo $screenres | awk '{print $4}')


# CREATE THE ADMIN IMAGE
   sudo sips -z $resH $resW -s format png -s formatOptions best "$templateImg" --out "$adminImg"


# RENAME THE DEFAULT HIGH SIERRA IMAGE AND THEN ADD OUR OWN IMAGE AS THE DEFAULT
   sudo mv "$hsImg" "/Library/Desktop Pictures/High Sierra2.jpg"
   sudo sips -z $resH $resW -s format jpeg -s formatOptions best "$templateImg" --out "$hsImg"


# RESET FILE OWNERSHIP
   sudo chown root:wheel "$adminImg"
   sudo chmod 755 "$adminImg"
   sudo chown root:wheel "$hsImg"
   sudo chmod 755 "$hsImg"
   sudo chown root:wheel "$templateImg"
   sudo chmod 755 "$templateImg"


exit 0
