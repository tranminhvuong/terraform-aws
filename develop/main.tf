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

module "route53" {
  source      = "../modules/aws/network_content_delivery/route53"
  project     = local.project
  environment = local.environment
  domain_name = "${var.common.env_prefix}.${var.common.root_domain}"
}

module "ses" {
  source          = "../modules/aws/ses"
  domain_name     = module.route53.domain_name
  route53_zone_id = module.route53.hosted_zone_id
  depends_on      = [module.route53]
}
