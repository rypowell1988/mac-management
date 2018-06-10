#!/bin/sh
# Executes Adobe Remote Update Manager to patch all installed Adobe CC Apps
#   Version: 1.0
#   Author: Ryan Powell
#   Reference: https://github.com/rypowell1988/mac-management/blob/master/ExecuteAdobeUpdateManager.sh


# CHECK RUM EXISTS
   if [[ ! -f /usr/local/bin/RemoteUpdateManager ]]; then
      echo "Remote Update Manager could not be found"
      exit 1
   fi


# EXECUTE RUM
   sudo /usr/local/bin/RemoteUpdateManager --action=install


exit 0
