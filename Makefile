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
cwd := $(notdir $(shell pwd))
key := /cdk/${cwd}/${env}

# parameters taken from cdk.json
ssm := $(shell jq .context.envs.${env} cdk.json)
ssm_account := $(shell jq -r .context.envs.${env}.account cdk.json)
ssm_region := $(shell jq -r .context.envs.${env}.region cdk.json)
ssm_cidr := $(shell jq -r .context.envs.${env}.vpc_config.cidr cdk.json)


reader:
	@echo "reading params for ${key}"
	@ssm_params=$(shell aws ssm get-parameters-by-path --output json --path ${key})
	@echo $(ssm_params)

uploader:
	@echo "uploading params"
	@aws ssm put-parameter --overwrite --name "${key}" --type String --value "${ssm}"
	#@aws ssm put-parameter --name "${key}/account" --type String --value "${ssm_account}"
	#@aws ssm put-parameter --name "${key}/region" --type String --value "${ssm_region}"
	#@aws ssm put-parameter --name "${key}/cidr" --type String --value "${ssm_cidr}"

deploy: uploader
	@cdk synth -c ssm_key=${key}

