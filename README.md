# www.shubaan.com

Infrastructure and deployment assets for the static website.

## Prerequisites

Before running Terraform or the deploy workflow, make sure you have AWS access configured.

### Local AWS credentials

Set up the AWS CLI and credentials if you have not already:

```bash
aws configure
```

This should create/update `~/.aws/credentials` and `~/.aws/config` with an access key that can manage S3, CloudFront, ACM, and Route53.

### GitHub Actions (OIDC)

If you want the GitHub Actions workflow to deploy, create an IAM role that trusts GitHub OIDC and grants the permissions below. Then add these repo secrets:

- `AWS_ROLE_ARN`
- `AWS_REGION` (e.g., `us-east-1`)
- `CLOUDFRONT_DISTRIBUTION_ID`
- `S3_BUCKET` (bucket name for site assets)

Example policy for the deploy role (scope it to your bucket and distribution):

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:ListBucket"],
      "Resource": "arn:aws:s3:::www.shubaan.com"
    },
    {
      "Effect": "Allow",
      "Action": ["s3:PutObject", "s3:DeleteObject", "s3:GetObject"],
      "Resource": "arn:aws:s3:::www.shubaan.com/*"
    },
    {
      "Effect": "Allow",
      "Action": ["cloudfront:CreateInvalidation"],
      "Resource": "arn:aws:cloudfront::<ACCOUNT_ID>:distribution/<DISTRIBUTION_ID>"
    }
  ]
}
```

## Provision AWS resources

The Terraform configuration creates:

- S3 bucket named after the domain (e.g., `www.shubaan.com`) with static website hosting.
- CloudFront distribution with an origin access control (OAC).
- ACM certificate (us-east-1) validated by Route53 DNS records.
- Route53 A/AAAA alias records pointing the domain to CloudFront.
- Site assets uploaded from the `site/` directory on `terraform apply`.

```bash
cd infra/terraform
terraform init
terraform apply \
  -var="domain_name=www.shubaan.com" \
  -var="s3_bucket_name=www.shubaan.com" \
  -var="zone_name=shubaan.com" \
  -var="use_existing_bucket=true"
```

If the bucket name is already taken by another AWS account, you must pick a different domain/bucket name because S3 bucket names are globally unique. Re-run `terraform apply` whenever you update files in `site/` to push the changes.

## Deploy site files

Upload static files from the `site/` directory and invalidate CloudFront so HTTPS content updates immediately:

```bash
aws s3 sync ./site s3://<bucket-name> --delete
aws cloudfront create-invalidation --distribution-id <distribution-id> --paths "/*"
```

## CI deploy

A GitHub Actions workflow is included. Configure the following GitHub secrets:

- `AWS_ROLE_ARN` (OIDC role with `s3:PutObject`, `s3:DeleteObject`, `cloudfront:CreateInvalidation`)
- `AWS_REGION` (e.g., `us-east-1`)
- `CLOUDFRONT_DISTRIBUTION_ID`
- `S3_BUCKET` (bucket name for site assets)

The workflow deploys `site/` on pushes to `main`.
