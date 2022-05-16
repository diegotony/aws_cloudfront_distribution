data "aws_route53_zone" "main" {
  name = "constant1n396.com"
}

resource "aws_route53_record" "blog" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "blog"
  type    = "CNAME"
  ttl     = "5"

  weighted_routing_policy {
    weight = 10
  }

  set_identifier = "blog"
  records        = [aws_cloudfront_distribution.my_cdn.domain_name]
}
