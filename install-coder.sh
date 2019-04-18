#!/bin/bash

while getopts v: option
do
case "${option}"
in
v) VERSION=${OPTARG};;
esac
done

echo "Installing version $VERSION"

binDir=$HOME/bin
if [ ! -d "$binDir" ]; then
	echo "- Creating $binDir"
	mkdir $binDir
fi


wget "https://github.com/codercom/code-server/releases/download/$VERSION/code-server$VERSION-linux-x64.tar.gz" && \
	tar -xvzf code-server$VERSION-linux-x64.tar.gz && \
	chmod +x ./code-server$VERSION-linux-x64/code-server && \
	mv ./code-server$VERSION-linux-x64/code-server $binDir/code-server

rm code-server$VERSION-linux-x64.tar.gz
rm -rf code-server$VERSION-linux-x64

echo "Done."

