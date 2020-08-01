#!/bin/bash
# 
# AWS CDK Deployment Wrapper
# ==========================
# [Requires bash dialog]
#
# Create a file containing the params to be uploaded to Stored Parameters
# and run the param_writer instruction.
#
# A check will be made and fail if you are overwriting existing params.
#
# To check the params are uploaded and in the correct order run param_reader.
# 
# You will now see the params uploaded and ready to be used by the CDK.
#
# Now run:
# deploy 
#
# This will create the CFN template and upload to the CFN service and start
# the deployment process.
#

################################
##
## Stored Parameters will follow the key pattern:
# /cdk/[Name of Git Repo]/[env]/[key]/
# 
# 
################################

set -e

# we use bash dialog so check it is installed
dialog_location=`which dialog`
if [ ! -f "$dialog_location" ]
then
  echo "Please install dialog.  yum install dialog (or similiar)"
fi

# global variables
MENUBOX=${MENUBOX=dialog}

# function declarations - start

# display menu
display_menu () {
  $MENUBOX --title "Deploy CDK Project" \
	   --menu "Use UP/DOWN arrow keys" \
	   15 45 4 \
	   1 "Upload Params to Stored Parameters" \
	   2 "Read Params from Stored Parameters" \
	   3 "Deploy CDK Project" \
	   X "Exit" \
	   2>choice
}

# function declarations - end




# script start
display_menu

case "`cat choice`" in
  1) echo "Uploading";;
  2) echo "Reading";;
  3) echo "Deploy";;
  X) echo "Exit";;
esac

#env ?= dev

#cdk synth -c env=${env}

# psuedo code
# display instructions and get environment type
# display menu page; upload_params, check_params, cdk_deploy
#
# results should be displayed in a dialog box


# 
