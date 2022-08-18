resource "aws_acm_certificate" "cert" {
  count  = var.certificate.enabled ? 1 : 0
  domain_name       = var.name
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}
