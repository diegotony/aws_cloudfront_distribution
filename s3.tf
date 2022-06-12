resource "aws_s3_bucket" "my_bucket" {
  bucket = var.name
}

data "aws_iam_policy_document" "my_bucket_s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.my_bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"]
    }
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = ["${aws_s3_bucket.my_bucket.arn}"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"]
    }
  }
}

resource "aws_s3_bucket_policy" "attach_policy_to_my_bucket" {
  bucket = "${aws_s3_bucket.my_bucket.id}"
  policy = "${data.aws_iam_policy_document.my_bucket_s3_policy.json}"
}
