resource "aws_acm_certificate" "cert" {
  domain_name       = var.name
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
  tags {
    Name = "${var.name}"
  }
}
output "acm_dns_validation" {
  value = "${aws_acm_certificate.cert.domain_validation_options}"
}
