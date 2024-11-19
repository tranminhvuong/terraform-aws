output "frontend_cert_arn" {
  value = aws_acm_certificate.cloudfront_frontend_cert.arn
}
