locals {
  domain = var.domain_name
}

resource "aws_ses_domain_identity" "main" {
  domain = local.domain
}

resource "aws_ses_domain_mail_from" "main" {
  domain           = aws_ses_domain_identity.main.domain
  mail_from_domain = "bounce.${aws_ses_domain_identity.main.domain}"
}

resource "aws_route53_record" "example_amazonses_verification_record" {
  zone_id = var.route53_zone_id
  name    = "_amazonses.${local.domain}"
  type    = "TXT"
  ttl     = "600"
  records = [aws_ses_domain_identity.main.verification_token]
}

resource "aws_ses_domain_dkim" "main" {
  domain = aws_ses_domain_identity.main.domain
}

# Route53 dkim record
resource "aws_route53_record" "example_amazonses_dkim_record" {
  count   = 3
  zone_id = var.route53_zone_id
  name    = "${aws_ses_domain_dkim.main.dkim_tokens[count.index]}._domainkey"
  type    = "CNAME"
  ttl     = "600"
  records = ["${aws_ses_domain_dkim.main.dkim_tokens[count.index]}.dkim.amazonses.com"]
}

# Route53 MX record
resource "aws_route53_record" "example_ses_domain_mail_from_mx" {
  zone_id = var.route53_zone_id
  name    = aws_ses_domain_mail_from.main.mail_from_domain
  type    = "MX"
  ttl     = "600"
  records = ["10 feedback-smtp.us-east-1.amazonses.com"]
}

# Route53 TXT record for SPF
resource "aws_route53_record" "example_ses_domain_mail_from_txt" {
  zone_id = var.route53_zone_id
  name    = aws_ses_domain_mail_from.main.mail_from_domain
  type    = "TXT"
  ttl     = "600"
  records = ["v=spf1 include:amazonses.com ~all"]
}

# Route53 TXT record for _dmarc
resource "aws_route53_record" "example_ses_domain_mail_from_dmarc" {
  zone_id = var.route53_zone_id
  name    = "_dmarc.${local.domain}"
  type    = "TXT"
  ttl     = "600"
  records = ["v=DMARC1;p=quarantine;rua=mailto:my_dmarc_report@${local.domain}"]
}
