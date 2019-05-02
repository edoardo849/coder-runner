#!/bin/bash

	source $HOME/.config/coder.conf && \
	code-server $WORKDIR $DATADIR $PORT $CERT $CERTKEY 
