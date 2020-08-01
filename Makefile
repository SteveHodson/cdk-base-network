#!/bin/bash
# 
# AWS CDK Deployment Wrapper
# ==========================
#
# Create a file containing the params to be uploaded to Stored Parameters
# and run the param_writer recipe adding the 'env' if needed.
# make param_writer [env=prod]
#
# To check the params are uploaded and in the correct order run:
# make param_reader [env=prod]
# 
# You will now see the params uploaded and ready to be used by the CDK.
#
# Now run:
# make deploy [env=prod]
# This will create the CFN template and upload to the CFN service and start
# the deployment process.
#

env ?= dev
cwd = $(notdir $(shell pwd))
key = "/cdk/${cwd}/${env}"

reader:
	@echo "reading params for ${key}"
	@ssm_params=$(shell aws ssm get-parameters-by-path --output json --path ${key})
	@echo $(ssm_params)

uploader:
	@echo "uploading params"
	@echo ${key} 

deploy: uploader
	@cdk synth -c ssm_key=${key}

