#!/bin/bash

while getopts v:c: option
do
case "${option}"
in
v) version=${OPTARG};;
c) cert=${OPTARG};;
esac
done



repo="codercom/code-server"

if [ -z "$version" ]
then
      echo "Checking the latest version from Github"
      version=$(curl --silent "https://api.github.com/repos/$repo/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")')
      echo "The latest release is $version"
fi

if [ -z "$cert" ]; then

	if [ ! -d "$HOME/.ssh" ]; then
		mkdir "$HOME/.ssh"
	fi

	openssl genrsa -passout pass:x -out $HOME/.ssh/coder_kp.key 2048
	openssl rsa -passin pass:x -in $HOME/.ssh/coder_kp.key -out $HOME/.ssh/coder.key
	rm $HOME/.ssh/coder_kp.key
	openssl req -new -key $HOME/.ssh/coder.key -out $HOME/.ssh/coder.csr
	openssl x509 -req -days 365 -in $HOME/.ssh/coder.csr -signkey $HOME/.ssh/coder.key -out $HOME/.ssh/coder.crt
	echo "Certificate generated in $HOME/.ssh"
fi


echo "Installing version $version"

binDir=$HOME/bin
if [ ! -d "$binDir" ]; then
	echo "- Creating $binDir"
	mkdir $binDir
fi


wget "https://github.com/codercom/code-server/releases/download/$version/code-server$version-linux-x64.tar.gz" && \
	tar -xvzf code-server$version-linux-x64.tar.gz && \
	chmod +x ./code-server$version-linux-x64/code-server && \
	mv ./code-server$version-linux-x64/code-server $binDir/code-server

rm code-server$version-linux-x64.tar.gz
rm -rf code-server$version-linux-x64

etcDir=$HOME/.config
if [ ! -d "$etcDir" ]; then
        echo "- Creating $etcDir"
        mkdir $etcDir
fi

if [ ! -f $etcDir/coder.conf ]; then
    cp ./example_coder.conf $etcDir/coder.conf
fi


echo "Done."

