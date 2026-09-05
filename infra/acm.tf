resource "aws_acm_certificate" "site" {
  domain_name       = "aws.sangharshjadhav.com"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "site" {
  certificate_arn         = aws_acm_certificate.site.arn
  validation_record_fqdns = [for option in aws_acm_certificate.site.domain_validation_options : option.resource_record_name]
}

output "acm_validation_records" {
  value = aws_acm_certificate.site.domain_validation_options
}
