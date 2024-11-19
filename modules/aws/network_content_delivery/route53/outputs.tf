output "domain_name" {
  value = aws_route53_zone.main.name
}
output "hosted_zone_id" {
  value = aws_route53_zone.main.zone_id
}

output "arn" {
  value = aws_route53_zone.main.arn
}
