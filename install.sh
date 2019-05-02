#!/bin/bash

install_l=false
while getopts v:ld: option; do
	case "${option}" in

	v)
		echo "Installing version $OPTARG"
		version=${OPTARG}
		;;
	l)
		echo "Installing letsencrypt"
		install_l=true
		;;
	d) domain=${OPTARG} ;;
	esac
done

confDir=$HOME/.config
if [ ! -d "$confDir" ]; then
	echo "- Creating $confDir"
	mkdir $confDir
fi

if [ ! -f $confDir/coder.conf ]; then
	cp ./example_coder.conf $confDir/coder.conf
fi

binDir=$HOME/bin
if [ ! -d "$binDir" ]; then
	echo "- Creating $binDir"
	mkdir $binDir
fi

repo="codercom/code-server"
do_install=true
echo "Checking the latest version from Github"
version=$(curl -L --silent "https://api.github.com/repos/$repo/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")')
echo "The latest release is $version"

# if the version variable is empty, exit
if [ -z "$version" ]; then
	echo "Could not retrieve the latest version"
	exit 1
fi

if [ -f $confDir/coder_latest.txt ]; then
	installed_version=$(cat "$confDir/coder_latest.txt")
	if [ "$version" == "$installed_version" ]; then
		echo "The latest version of coder is already installed"
		do_install=false
	else
		echo "Latest version is $version , installed is $installed_version , upgrading..."
	fi
fi

if [ "$do_install" == true ]; then
	echo "Installing version $version"
	wget "https://github.com/codercom/code-server/releases/download/$version/code-server$version-linux-x64.tar.gz" &&
		tar -xvzf code-server$version-linux-x64.tar.gz &&
		chmod +x ./code-server$version-linux-x64/code-server &&
		mv ./code-server$version-linux-x64/code-server $binDir/code-server

	echo "Cleaning up"
	rm code-server$version-linux-x64.tar.gz &&
		rm -rf code-server$version-linux-x64

	echo "$version" >$confDir/coder_latest.txt
fi

# if the -l flag is not empty, install letsencrypt
if [ "$install_l" == true ]; then

	if [ -z "$domain" ]; then
		echo "The domain -d flag must be set"
		exit
	fi
	echo "Installing certbot COMING SOON"

fi

echo "Done."
