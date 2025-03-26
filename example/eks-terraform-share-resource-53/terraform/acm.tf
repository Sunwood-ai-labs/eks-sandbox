# SSL/TLS証明書の作成
resource "aws_acm_certificate" "main" {
  domain_name               = var.domain
  subject_alternative_names = ["*.${var.domain}"]  # ワイルドカード証明書
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = var.default_tags
}

# DNS検証用のレコードを作成
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.main.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.route53_zone_id
}

# 証明書の検証完了を待機
resource "aws_acm_certificate_validation" "main" {
  certificate_arn         = aws_acm_certificate.main.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

# 証明書のARNを出力
output "certificate_arn" {
  description = "ARN of the issued certificate"
  value       = aws_acm_certificate.main.arn
}
