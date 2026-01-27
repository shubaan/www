output "bucket_name" {
  value       = aws_s3_bucket.site.id
  description = "S3 bucket that stores the site assets."
}

output "cloudfront_domain" {
  value       = aws_cloudfront_distribution.site.domain_name
  description = "CloudFront distribution domain name."
}

output "site_domain" {
  value       = var.domain_name
  description = "Primary site domain name."
}
