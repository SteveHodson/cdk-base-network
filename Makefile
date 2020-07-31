#!/bin/bash

# Wrapper for cdk deploy (adding commandline param that
# determines what Stored Parameters to read).
# and uploading params to Stored Parameters
#
# Before uploading process needs to check for existing 
# params as we don't want to over write existing params.
#
env ?= dev

deploy:
	@cdk synth -c env=${env}
