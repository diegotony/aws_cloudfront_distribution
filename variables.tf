variable "name" {
  type        = string
  description = "distribution name"
}

variable "custom_error_response" {
  type = list(object({
    error_caching_min_ttl = number,
    error_code            = number,
    response_code         = number,
    response_page_path    = string,
  }))
  default = [ {
    error_caching_min_ttl = 1
    error_code = 404
    response_code = 200
    response_page_path = "/index.html"
  } ]
}

variable "tags" {
  type = map(any)
  default = {
    "service" = "aws_cloudront_distribution"
  }
  description = "tags"
}

# TODO
# Add Validations