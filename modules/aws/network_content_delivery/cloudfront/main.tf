resource "aws_cloudfront_distribution" "frontend_distribution" {
  origin {
    domain_name = var.frontend_bucket_regional_domain_name
    origin_id   = var.frontend_bucket_regional_domain_name

    s3_origin_config {
      origin_access_identity = var.cloudfront_access_identity_path
    }
  }
  comment             = "${var.project}-${var.environment}-frontend-distribution"
  enabled             = true
  is_ipv6_enabled     = false
  default_root_object = "index.html"
  price_class         = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  default_cache_behavior {
    target_origin_id       = var.frontend_bucket_regional_domain_name
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }
    }
  }
  aliases = ["${var.domain_name}", "www.${var.domain_name}"]

  viewer_certificate {
    acm_certificate_arn            = var.frontend_acm_arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
    cloudfront_default_certificate = false
  }
  tags = {
    Env     = var.environment
    Project = var.project
  }
}
