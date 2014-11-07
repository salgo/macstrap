#!/bin/bash 

set -e
source "bash_lib/colours.sh"

echo 
coloured_msg $txtbld "Mac workstation bootstrap"
echo "- By Andy Gale <andy@hellofutu.re>"

if [ ! -f "chefdk.dmg" ]
then
    echo 
    coloured_msg $bldblu "Downloading ChefDK..."
    echo

    curl "https://opscode-omnibus-packages.s3.amazonaws.com/mac_os_x/10.8/x86_64/chefdk-0.3.2-1.dmg" -o "chefdk.dmg"
else
    echo
    echo "ChefDK downloaded"
fi

MOUNT=`mount | grep /Volumes/Chef\ Development\ Kit`


if [ -z "$MOUNT" ]
then
    echo
    coloured_msg $bldblu "Attaching ChefDK .dmg"
    echo
    hdiutil attach chefdk.dmg
else
    echo
    echo "ChefDK .dmg attached"
fi

if [ -z `which chef` ]
then
    echo
    coloured_msg $bldblu "Installing ChefDK"
    echo

    sudo installer -pkg /Volumes/Chef\ Development\ Kit/chefdk-0.3.2-1.pkg -target /
else
    echo
    echo "ChefDK installed"
fi

sudo chown -R `whoami`:staff /usr/local
