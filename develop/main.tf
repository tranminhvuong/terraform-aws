locals {
  project     = var.common.project
  environment = var.common.environment
}

module "vpc_main" {
  source          = "../modules/aws/network"
  project         = local.project
  environment     = local.environment
  private_subnets = var.vpc.private_subnets
  public_subnets  = var.vpc.public_subnets
  cidr            = var.vpc.cidr
}
