#!/bin/bash
#
# v1.0 - Initial release - @hrbrmstr
#
# Script to turn a R+Shiny gist into a one-click OS X application
#
# Just enter in the gist ID and the app name you want, optionally providing
# a custom icns file and also optionally code-signing the built app
#
# It does rudimentary checking to ensure the gist id is, in fact a Shiny app.
#
# To code-sign, you need to be a registered Apple developer for Mac OS. See
#
# https://developer.apple.com/library/mac/documentation/Security/Conceptual/CodeSigningGuide/Introduction/Introduction.html 
#
# for more info on code-signing
#
#
# Examples:
# 
# $ shinyapp 95ec24c1b0cb433a76a5 "Shiny Snowfall"
# $ shinyapp -d 'Bob Rudis (CBY22P58G8)' 95ec24c1b0cb433a76a5 'Shiny Snowfall'
# $ shinyapp -i snowcloud.icns -d 'Bob Rudis (CBY22P58G8)' 95ec24c1b0cb433a76a5 'Shiny Snowfall'
#

SCRIPT=`basename ${BASH_SOURCE[0]}`

dev_id=""
icns_file=""

function HELP {
  echo "${SCRIPT} 1.0, turns a R+Shiny gist into an OS X app"
  echo -e "Usage: ${SCRIPT} [-i icns_file] [-d developer_id] gist_id app_name "\\n
  echo -e "Command line switches are optional. The following switches are recognized."\\n
  echo " -d    the Apple code-signing Developer Id to use when code-signing;"
  echo "       setting this option will cause ${SCRIPT} to code-sign the compiled app."
  echo " -i    path to the icns file to use for the app;"
  echo "       leaving this blank will use the default icns set."
  echo -e " -h    displays this help message."\\n
  echo -e " Example: ${SCRIPT} -d 'Bob Rudis (CBY22P58G8)' 95ec24c1b0cb433a76a5 'Shiny Snowfall'"\\n
  exit 1
}

NUMARGS=$#
if [ $NUMARGS -eq 0 ]; then
  HELP
fi

while getopts :d:i:h FLAG; do
  case $FLAG in
    d)  
      dev_id=$OPTARG
      ;;
    i)  
      icns_file=$OPTARG
      ;;
    h)
      HELP
      ;;
    \?) 
      echo -e \\n"Option -$OPTARG not expected."
      HELP
      ;;
  esac
done

shift $((OPTIND-1))

gist_id=$1
app_name="${2}.app"

if [ "$app_name" == ".app" ]; then
	echo -e \\n"ERROR: application name not specified"\\n
	HELP
fi

if [ ! "$icns_file" == "" ]; then

  echo "Checking if icns file exists..."

  if [ ! -f "$icns_file" ]; then
  	echo -e \\n"ERROR: icns file: '${icns_file}' not found"\\n
	HELP
  fi

fi

echo "Checking if gist [$gist_id] exists..."

status=$(curl --silent --location --head --write-out %{http_code} "https://gist.github.com/${gist_id}" --output /dev/null)
if [ ! "$status" == "200" ]; then
	echo -e \\n"ERROR: gist '${gist_id}' not found"\\n
	HELP
else
	echo "Checking if gist [$gist_id] is a Shiny app..."
	found=`curl --silent --location  "https://gist.github.com/${gist_id}/download" | tar ztvf - 2> /dev/null | grep server.R`
    if [ "$found" == "" ]; then
    	echo -e \\n"ERROR: gist [$gist_id] found but is not a Shiny application"\\n
    	HELP
    fi
fi

echo "Checking if ${app_name} already exists..."

if [ -d "$app_name" ] ; then
	echo -e \\n"ERROR ${app_name} already exists"\\n
	HELP
fi

TMPFILE=`mktemp -t shinyappscript.XXXXXX` || exit 1
echo 'tell application "R"' >> $TMPFILE
echo '    activate' >> $TMPFILE
echo '    set miniaturized of window 1 to true' >> $TMPFILE
echo "    cmd \"shiny::runGist('${gist_id}', launch.browser=TRUE)\"" >> $TMPFILE
echo 'end tell' >> $TMPFILE

echo "Compiling AppleScript..."
/usr/bin/osacompile -o "$app_name" $TMPFILE

rm $TMPFILE

if [ ! "$icns_file" == "" ]; then
	echo "Copying icns file..."
	cp "$icns_file" "${app_name}/Contents/Resources/applet.icns"
fi


if [ ! "$dev_id" == "" ]; then
	echo "Code signing [${app_name}] with [${dev_id}]..."
	codesign --force --sign "Developer ID Application: ${dev_id}" "$app_name"
fi


