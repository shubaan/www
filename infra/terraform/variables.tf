variable "aws_region" {
  type        = string
  description = "Primary AWS region for S3 and Route53 changes."
  default     = "us-east-1"
}

variable "domain_name" {
  type        = string
  description = "Primary domain name for the site (e.g., shubaan.com)."
}

variable "alternate_domains" {
  type        = list(string)
  description = "Additional domain names (SANs) for the CloudFront distribution and ACM certificate."
  default     = []
}

variable "s3_bucket_name" {
  type        = string
  description = "Optional S3 bucket name override. Defaults to the domain name when unset."
  default     = null
}

variable "use_existing_bucket" {
  type        = bool
  description = "Use an existing S3 bucket instead of creating a new one."
  default     = false
}

variable "zone_name" {
  type        = string
  description = "Route53 hosted zone name (e.g., shubaan.com)."
}

variable "content_types" {
  type        = map(string)
  description = "Optional map of content types keyed by relative site file path."
  default     = {}
}
