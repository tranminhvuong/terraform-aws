resource "aws_route53_zone" "main" {
  name = var.domain_name
  tags = {
    Env     = var.environment
    Project = var.project
  }
}
