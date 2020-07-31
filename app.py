#!/usr/bin/env python3

from aws_cdk import core

from network.network_stack import NetworkStack


app = core.App()

# define the environment to be used
env = app.node.try_get_context('env')
print(env)
context = app.node.try_get_context('envs')[env]

print(context)

env = core.Environment(
    account=context['account'],
    region=context['region']
)

NetworkStack(app, "network", env=env)

app.synth()
