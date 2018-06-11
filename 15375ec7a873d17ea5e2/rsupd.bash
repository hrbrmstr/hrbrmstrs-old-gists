#!/bin/bash

# this script relies on the W3C HTML XML tools and the "trash" utility
# the easiest way to install them is to install homebrew http://brew.sh/
# then:
# brew install html-xml-utils trash

rstudio_osx_daily_url="https://www.rstudio.org/download/daily/desktop/mac/"

# Get URL for "latest" RStudio daily
url=`curl --silent "${rstudio_osx_daily_url}" | hxselect "tr#row0 > td > a" | sed -e 's/<a /<a /g' | sed -e 's/<a .*href=['"'"'"]//' -e 's/["'"'"'].*$//' -e '/^$/ d'`

# Get just the name of the dmg file
fil=`basename ${url}`

# Download the daily dmg
cd /tmp
rm RStudio*dmg
curl --silent --output "${fil}" "${url}"

# Mount it
atch=`hdiutil attach ${fil}`

# Get the mount location
vol=${atch##* }

# Get rid of the old RStudio app
trash /Applications/RStudio.app

# Put the new one in /Applications
ditto ${vol}/RStudio.app /Applications/RStudio.app

# Unmount the dmg
umount ${vol}
