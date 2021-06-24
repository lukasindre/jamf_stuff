#!/bin/sh

hdiutil create -o /tmp/MacOSBigSur -size 16500m -volname MacOSBigSur -layout SPUD -fs HFS+J

hdiutil attach /tmp/MacOSBigSur.dmg -noverify -mountpoint /Volumes/MacOSBigSur

/Applications/Install\ macOS\ Big\ Sur.app/Contents/Resources/createinstallmedia --volume /Volumes/MacOSBigSur --nointeraction

hdiutil detach /Volumes/MacOSBigSur/

mv /tmp/MacOSBigSur.dmg ~/Desktop/
