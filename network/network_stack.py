from aws_cdk import (
    core,
    aws_ec2 as ec2
)


class NetworkStack(core.Stack):

    def __init__(self, scope: core.Construct, id: str, **kwargs) -> None:

        # grab the context and pop it out as the super
        # class only accepts 'env'
        self.vpc_config = kwargs['context']['vpc_config']
        kwargs.pop('context')

        super().__init__(scope, id, **kwargs)

        # cidr block to use for this vpc
        self.cidr=self.vpc_config.get('cidr')

        # number of AZs to use (default = 2)
        self.num_azs = int(self.vpc_config.get('zones', 2))

        # number of distinct layers within the network
        # (default = 2)
        layers = int(self.vpc_config.get('layers', 2))
        self.subnet_configurations = self._create_subnets(layers)

        self.vpc = ec2.Vpc(
            self, "VPC",
            max_azs=self.num_azs,
            cidr=self.cidr,
            subnet_configuration=self.subnet_configurations,
        )
    
    # A wrapper to create a list of subnet configurations
    def _create_subnets(self, layers):
        subnets = []
        for layer in range(1,layers+1):
            subnets.append(self._create_subnet(layer))
        return subnets
    
    # Algorithm will create a SubnetConfiguration using the layers
    # Each config will be half the size of the previous in the order;
    # private, public, isolated, isolated...
    def _create_subnet(self, layer):
        mask = int(self.cidr[-2:]) + layer + self.num_azs

        if layer == 1:
            return ec2.SubnetConfiguration(
                name="Private",
                subnet_type=ec2.SubnetType.PRIVATE,
                cidr_mask=mask
            )
        if layer == 2:
            return ec2.SubnetConfiguration(
                name="Public",
                subnet_type=ec2.SubnetType.PUBLIC,
                cidr_mask=mask
            )
        if layer > 2:
            return ec2.SubnetConfiguration(
                name="Isolated",
                subnet_type=ec2.SubnetType.ISOLATED,
                cidr_mask=mask
            )
