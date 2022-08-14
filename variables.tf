variable "name" {
    type = string
    description = "CDN name"
}

variable "cartificate" {
    type = bool
    description = "In case that you want a your have a certficate"
}

variable custom_error_response {
    type = list(object({
    error_caching_min_ttl = number,
    error_code            = number,
    response_code        = number,
    response_page_path    = string,        
    }))
}