output "frontend" {
  value = {
    domain_name    = aws_cloudfront_distribution.frontend_distribution.domain_name
    hosted_zone_id = aws_cloudfront_distribution.frontend_distribution.hosted_zone_id
  }
}
