#!/bin/bash

source $HOME/.config/coder.conf && \
	$HOME/bin/code-server $WORKDIR $DATADIR $PORT $PWD $CERT $CERTKEY 
