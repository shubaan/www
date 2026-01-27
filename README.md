# www.shubaan.com

Infrastructure and deployment assets for the static website.

## Provision AWS resources

The Terraform configuration creates:

- S3 bucket named after the domain (e.g., `www.shubaan.com`) with static website hosting.
- CloudFront distribution with an origin access control (OAC).
- ACM certificate (us-east-1) validated by Route53 DNS records.
- Route53 A/AAAA alias records pointing the domain to CloudFront.

```bash
cd infra/terraform
terraform init
terraform apply \
  -var="domain_name=www.shubaan.com" \
  -var="zone_name=shubaan.com"
```

## Deploy site files

Upload static files from the `site/` directory and invalidate CloudFront so HTTPS content updates immediately:

```bash
aws s3 sync ./site s3://www.shubaan.com --delete
aws cloudfront create-invalidation --distribution-id <distribution-id> --paths "/*"
```

## CI deploy

A GitHub Actions workflow is included. Configure the following GitHub secrets:

- `AWS_ROLE_ARN` (OIDC role with `s3:PutObject`, `s3:DeleteObject`, `cloudfront:CreateInvalidation`)
- `AWS_REGION` (e.g., `us-east-1`)
- `CLOUDFRONT_DISTRIBUTION_ID`

The workflow deploys `site/` on pushes to `main`.
