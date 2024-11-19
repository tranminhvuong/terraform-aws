resource "aws_s3_bucket" "web_frontend" {
  bucket = "${var.project}-${var.environment}-frontend-s3-bucket"
}

resource "aws_cloudfront_origin_access_identity" "frontend_oai" {
  comment = "OAI for CloudFront accessing S3 bucket"
}

resource "aws_s3_bucket_policy" "example" {
  bucket = aws_s3_bucket.web_frontend.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = aws_cloudfront_origin_access_identity.frontend_oai.iam_arn
        }
        Action = ["s3:GetObject", "s3:ListBucket"]
        Resource = [
          "${aws_s3_bucket.web_frontend.arn}",  # ListBucket action
          "${aws_s3_bucket.web_frontend.arn}/*" # GetObject action
        ]
      }
    ]
  })
}

resource "aws_s3_bucket" "storage" {
  bucket = "${var.project}-${var.environment}-storage-s3-bucket"
}

# resource "aws_s3_bucket_policy" "storage_policy" {
#   bucket = aws_s3_bucket.storage.id
#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect = "Allow"
#         Principal = {
#           AWS = aws_cloudfront_origin_access_identity.frontend_oai.iam_arn
#         }
#         Action = ["s3:GetObject", "s3:ListBucket"]
#         Resource = [
#           "${aws_s3_bucket.web_frontend.arn}",  # ListBucket action
#           "${aws_s3_bucket.web_frontend.arn}/*" # GetObject action
#         ]
#       }
#     ]
#   })
# }
