#!/bin/bash

source $HOME/etc/coder.conf && \
	$HOME/bin/code-server $WORKDIR $DATADIR $PORT $PWD $CERT $CERTKEY 
