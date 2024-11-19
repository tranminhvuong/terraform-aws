locals {
  project     = var.project
  environment = var.environment

  vpc = {
    cidr            = var.cidr
    public_subnets  = var.public_subnets
    private_subnets = var.private_subnets
  }
}

module "vpc" {
  source                                          = "terraform-aws-modules/vpc/aws"
  name                                            = "${local.project}-${local.environment}-vpc"
  cidr                                            = local.vpc.cidr
  azs                                             = data.aws_availability_zones.available.names
  public_subnets                                  = local.vpc.public_subnets
  private_subnets                                 = local.vpc.private_subnets
  enable_nat_gateway                              = true
  enable_vpn_gateway                              = false
  single_nat_gateway                              = true
  one_nat_gateway_per_az                          = false
  enable_dns_hostnames                            = true
  enable_dns_support                              = true
  enable_flow_log                                 = true
  flow_log_destination_type                       = "cloud-watch-logs"
  create_flow_log_cloudwatch_log_group            = true
  create_flow_log_cloudwatch_iam_role             = true
  flow_log_max_aggregation_interval               = 600
  vpc_flow_log_iam_policy_name                    = "${local.project}-${local.environment}-vpc-flow-log-policy"
  flow_log_cloudwatch_log_group_class             = "STANDARD"
  flow_log_cloudwatch_log_group_retention_in_days = 90
  vpc_tags = {
    Env     = local.environment
    Project = local.project
  }
  nat_gateway_tags = {
    Env     = local.environment
    Project = local.project
    Name    = "${local.project}-${local.environment}-natgw"
  }
  vpc_flow_log_tags = {
    Env     = local.environment
    Project = local.project
    Name    = "${local.project}-${local.environment}-vpc-flow-log"
  }
}
