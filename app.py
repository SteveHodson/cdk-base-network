#!/usr/bin/env python3

from aws_cdk import core

from network.network_stack import NetworkStack


app = core.App()
NetworkStack(app, "network")

app.synth()
