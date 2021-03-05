#!/bin/bash

#Find latest Slack version / Pulls Version from Slack for Mac download page
currentSlackVersion=$(/usr/bin/curl -sL 'https://slack.com/release-notes/mac/rss' | grep -o "Slack-[0-9]\.[0-9]\.[0-9]"  | cut -c 7-11 | head -n 1)

# Install Slack function
install_slack() {
	#Slack download variables
	slackDownloadUrl=$(curl "https://slack.com/ssb/download-osx-silicon" -s -L -I -o /dev/null -w '%{url_effective}')
	dmgName=$(printf "%s" "${slackDownloadUrl[@]}" | sed 's@.*/@@')
	slackDmgPath="/tmp/$dmgName"
	CURRENT_USER=$(/bin/ls -l /dev/console | /usr/bin/awk '{ print $3 }')


	# Begin download

	# Download latest version of Slack
	curl -L -o "$slackDmgPath" "$slackDownloadUrl"

	# mount dmg
	hdiutil attach -nobrowse $slackDmgPath

    # Copy the update app into applications folder
    mkdir -p /Users/$CURRENT_USER/Applications
    cp -R /Volumes/Slack*/Slack.app /Users/$CURRENT_USER/Applications

	# Change ownership of Slack
	chown -R $CURRENT_USER:staff /Users/$CURRENT_USER/Applications
	chown -R $CURRENT_USER:staff /Users/$CURRENT_USER/Applications/Slack.app

	# Unmount and eject dmg
	mountName=$(diskutil list | grep Slack | awk '{ print $3 }')
	umount -f /Volumes/Slack.app/
	diskutil eject $mountName

	# cleanup /tmp download
	rm -rf "$slackDmgPath"
}

LOGGED_IN_USER=$(/bin/ls -l /dev/console | /usr/bin/awk '{ print $3 }')

# check if Slack installed
if [ ! -d "/Users/${LOGGED_IN_USER}/Applications/Slack.app" ]; then
	echo "=> Slack.app is not installed"
	install_slack
fi
