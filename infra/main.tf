provider "aws" {
  region                  = "us-east-1"
  profile                 = "default"
  shared_credentials_file = "~/.aws/credentials"
}

terraform {
  //backend "s3" { configurue your backend here
  //}
}
#########################################################

locals {
  domain = var.domain_name
}

module "acm_request_certificate" {
  source                      = "cloudposse/acm-request-certificate/aws"
  version                     = "0.7.0"
  domain_name                 = var.hosted_zone
  wait_for_certificate_issued = true
}

data "aws_route53_zone" "zone" {
  name = "nuro.tools"
}

module "cloudfront-s3-cdn" {
  source             = "cloudposse/cloudfront-s3-cdn/aws"
  version            = "0.34.1"
  name               = "foo"
  encryption_enabled = true
  environment = var.env
  # DNS Settings
  parent_zone_id      = data.aws_route53_zone.zone.id
  acm_certificate_arn = module.acm_request_certificate.arn
  aliases             = [local.domain]
  ipv6_enabled        = true
  # Caching Settings
  default_ttl = 300
  compress    = true
  # Website settings
  website_enabled = true
  index_document  = "index.html" # absolute path in the S3 bucket
  error_document  = "index.html" # absolute path in the S3 bucket
  #depends_on      = [module.acm_request_certificate]
}
output s3_bucket {
  description = "Name of the S3 origin bucket"
  value       = module.cloudfront-s3-cdn.s3_bucket
}
