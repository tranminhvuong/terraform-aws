locals {
  project     = var.common.project
  environment = var.common.environment
}

# module "vpc_main" {
#   source          = "../modules/aws/network"
#   project         = local.project
#   environment     = local.environment
#   private_subnets = var.vpc.private_subnets
#   public_subnets  = var.vpc.public_subnets
#   cidr            = var.vpc.cidr
# }

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

module "s3_storage" {
  source      = "../modules/aws/storage/s3"
  project     = local.project
  environment = local.environment
}

module "cloudfront" {
  source                               = "../modules/aws/network_content_delivery/cloudfront"
  project                              = local.project
  environment                          = local.environment
  cloudfront_access_identity_path      = module.s3_storage.frontend.cloudfront_access_identity_path
  frontend_bucket_id                   = module.s3_storage.frontend.id
  frontend_bucket_regional_domain_name = module.s3_storage.frontend.bucket_regional_domain_name
  domain_name                          = module.route53.domain_name
  frontend_acm_arn                     = module.acm.frontend_cert_arn
}

module "acm" {
  source         = "../modules/aws/security/acm"
  project        = local.project
  environment    = local.environment
  domain_name    = module.route53.domain_name
  hosted_zone_id = module.route53.hosted_zone_id
}

resource "aws_route53_record" "frontend_record" {
  zone_id = module.route53.hosted_zone_id
  name    = module.route53.domain_name
  type    = "A"
  alias {
    name                   = module.cloudfront.frontend.domain_name
    zone_id                = module.cloudfront.frontend.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www_frontend_record" {
  zone_id = module.route53.hosted_zone_id
  name    = "www.${module.route53.domain_name}"
  type    = "A"
  alias {
    name                   = module.cloudfront.frontend.domain_name
    zone_id                = module.cloudfront.frontend.hosted_zone_id
    evaluate_target_health = false
  }
}
