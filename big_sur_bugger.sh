#!/bin/sh

#################################################################################################################################
#
# Author: Lukas Indre
# Date: 2021-06-24
#
# Description: This script will create a dialog box on the user's machine asking them to upgrade their Big Sur version.  This
#              window will close after a user selects a button of 'Not right now' or 'Upgrade now', or after 3600 seconds.
#              If they say yes, Software Update preference pane will open (since standard users can update Big Sur on their own).
#              If they say no, or the window times out, another window will pop up stating we will ask them again tomorrow.  That 
#              window will close after 5 seconds.
#
#################################################################################################################################

/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility \
	-title 'Upstart IT' \
	-heading 'Big Sur Update Required!' \
	-description 'Something about how Big Sur is important' \
	-icon /Users/Shared/IT\ Resources/upstart.png \
	-button1 'Upgrade now' \
	-button2 'Not right now' \
	-defaultButton 1 \
	-timeout 3600 \
	-cancelButton 2 &> /dev/null
	
if [[ $? -eq 0 ]]
then
	open -b com.apple.systempreferences /System/Library/PreferencePanes/SoftwareUpdate.prefPane

	exit 0
else
	/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility \
		-title 'Upstart IT' \
		-heading 'Big Sur Update Required!' \
		-description 'We will ask you again tomorrow :)' \
		-icon /Users/Shared/IT\ Resources/upstart.png \
		-timeout 5

	exit 0
fi
