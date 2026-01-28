variable "aws_region" {
  type        = string
  description = "Primary AWS region for S3 and Route53 changes."
  default     = "us-east-1"
}

variable "domain_name" {
  type        = string
  description = "Domain name for the site and S3 bucket (e.g., www.shubaan.com)."
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
