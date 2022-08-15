locals {
  tags                  = { template = "tf-modules", service = "aws_cloudfront_distribution" }
  custom_error_response = length(var.custom_error_response) == 0 ? null : var.custom_error_response
  aws_acm_certificate   = try(aws_acm_certificate.cert.arn, "nope")
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
}

data "aws_acm_certificate" "cert" {
  count  = var.certificate.enabled ? 1 : 0
  domain = var.certificate.name
}

resource "aws_cloudfront_distribution" "my_cdn" {
  origin {
    domain_name = aws_s3_bucket.my_bucket.bucket_regional_domain_name
    origin_id   = "${var.name}origin"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = var.certificate.enabled ? null : ["${var.name}"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${var.name}origin"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
    compress               = true
    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  price_class = "PriceClass_200"

  viewer_certificate {
    cloudfront_default_certificate = var.certificate.enabled ? true : null
    acm_certificate_arn            = var.certificate.enabled ? null : "${local.aws_acm_certificate}"
    ssl_support_method             = var.certificate.enabled ? null : var.certificate.ssl_support_method
    minimum_protocol_version       = var.certificate.minimum_protocol_version
  }

  dynamic "custom_error_response" {
    for_each = var.custom_error_response
    content {
      error_caching_min_ttl = custom_error_response.value.error_caching_min_ttl
      error_code            = custom_error_response.value.error_code
      response_code         = custom_error_response.value.response_code
      response_page_path    = custom_error_response.value.response_page_path
    }
  }

  tags = merge(var.tags, local.tags)

}
