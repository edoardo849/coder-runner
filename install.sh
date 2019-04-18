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

	if [ ! -d "./certs" ]; then
		mkdir "./certs"
	fi

	openssl genrsa -passout pass:x -out ./certs/coder_kp.key 2048
	openssl rsa -passin pass:x -in ./certs/coder_kp.key -out ./certs/coder.key
	rm ./certs/coder_kp.key
	openssl req -new -key ./certs/coder.key -out ./certs/coder.csr
	openssl x509 -req -days 365 -in ./certs/coder.csr -signkey ./certs/coder.key -out ./certs/coder.crt
	echo "Certificate generated in ./certs"
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

etcDir=$HOME/etc
if [ ! -d "$etcDir" ]; then
        echo "- Creating $etcDir"
        mkdir $etcDir
fi

if [ ! -f $etcDir/coder.conf ]; then
    cp ./example_coder.conf $etcDir/coder.conf
fi


echo "Done."

