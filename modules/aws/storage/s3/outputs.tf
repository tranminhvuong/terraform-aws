output "frontend" {
  value = {
    bucket_regional_domain_name     = aws_s3_bucket.web_frontend.bucket_regional_domain_name
    id                              = aws_s3_bucket.web_frontend.id
    cloudfront_access_identity_path = aws_cloudfront_origin_access_identity.frontend_oai.cloudfront_access_identity_path
  }
}

output "storage" {
  value = {
    bucket_regional_domain_name = aws_s3_bucket.storage.bucket_regional_domain_name
    id                          = aws_s3_bucket.storage.id
  }
}
