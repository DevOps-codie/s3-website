# S3-website-cloudfront-project
 The code in this repo will build a static s3 website with cloudfront and an edge lambda for redirects using cloudposse aws-cloudfront-s3-cdn terraform modules.
  The code terraform code in this repo will do the following below
  - Set up an S3 bucket to host your website.
  - Set up a CloudFront distribution to act as a content delivery network (CDN) for the files in your S3 bucket
  - Use CloudFront origin access identity to protect your S3 contents from sources outside of your CDN
  - Creating an SSL/TLS certificate using the AWS Certificate Manager (ACM).
  - Pointing your domain names to your CloudFront distribution using Route53.
  - Create a lambda (nodejs) that will do a redirect for you.

This repo has contains a dev and prod github action yaml to delpoy your website 
(now you can build 2 separate environments for dev or prod by adding an env vars to the terraform code, so you can create a dev or prod env, but as it stands it will just build you a single environment but both github action files are included as requirements for this exercise)
If you need to run the code without the github action it can be done with the follwing commands below. Remeber to add your terraform backend config to main.tf.
```
terraform get
```
```
terraform plan
```
```
terraform apply
```

### Generating ACM Certificate

Use the AWS cli to [request new ACM certifiates](http://docs.aws.amazon.com/acm/latest/userguide/gs-acm-request.html) (requires email validation)
```
aws acm request-certificate --domain-name example.com --subject-alternative-names a.example.com b.example.com *.c.example.com
```

### Github vars 
You will NEED to set you varibales in github so you github actions can work, see the documentation below on how to do so.
To creating encrypted secrets for a repository.
To create secrets for a user account repository, you must be the repository owner. To create secrets for an organization repository, you must have admin access.

- Use the documentation here 
https://docs.github.com/en/actions/reference/encrypted-secrets

###
REPO MAP 

![TERRAFORM RULES!](./map.png)
