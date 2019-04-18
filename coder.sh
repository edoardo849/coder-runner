#!/bin/bash

source $HOME/etc/code-server.conf && \
	$HOME/bin/code-server $WORKDIR $DATADIR $PORT $PWD $CERT $CERTKEY 
