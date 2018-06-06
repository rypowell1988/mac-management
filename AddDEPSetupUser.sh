#!/bin/sh
# If the Mac is enrolled via DEP then the DEPSetupUser is added (Via Jamf Policy), Auto Login enabled and reboot scheduled
#   Version: 1.0
#   Author: Ryan Powell
#   Reference: https://github.com/rypowell1988/mac-management/blob/master/AddDEPSetupUser.sh

# GET ENROLLMENT METHOD
depEnabled=`profiles status -type enrollment | grep 'Enrolled via DEP:' | awk '{print $4}'`

if [[ $depEnabled == 'Yes' ]]; then
    sudo /usr/local/jamf/bin/jamf policy -trigger pkg_adddepsetupaccount
    
    # SCHEDULE A REBOOT IN ONE MINUTE
    sudo shutdown -h +1 &
    
    # EXIT SUCCESSFULL
    exit 0
fi

# EXIT FAILURE IF NOT ENROLLED VIA DEP
exit 2
