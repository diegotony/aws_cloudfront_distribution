resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
}

data "aws_acm_certificate" "cert" {
  domain   = var.certificate_name
}

resource "aws_cloudfront_distribution" "my_cdn" {
  origin {
    domain_name = "${aws_s3_bucket.blog.bucket_regional_domain_name}"
    origin_id   = "${var.name}origin"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = ["${var.name}"] # Add Conditional

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
    compress = true
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
    acm_certificate_arn = "${aws_acm_certificate.cert.arn}" # Add Conditional
    ssl_support_method = "sni-only" # Add Conditional
    minimum_protocol_version = "TLSv1.2_2021" # Add Conditional
  }

}