#!/usr/bin/env python3

from aws_cdk import core

from network.network_stack import NetworkStack


app = core.App()

# define the environment to be used (default is dev)
env = app.node.try_get_context('env')
if env is None:
    env = "dev"

context = app.node.try_get_context('envs')[env]
print(context['account'])
env = core.Environment(
    account=context['account'],
    region=context['region']
)

NetworkStack(app, "network", env=env, context=context)

app.synth()
