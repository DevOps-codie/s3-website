# s3-website
builds a s3 website with cloudfront  using cloudposse aws-cloudfront-s3-cdn
you will first need to run the command below to generate the ACM cert via the cli 

### Generating ACM Certificate

Use the AWS cli to [request new ACM certifiates](http://docs.aws.amazon.com/acm/latest/userguide/gs-acm-request.html) (requires email validation)
```
aws acm request-certificate --domain-name example.com --subject-alternative-names a.example.com b.example.com *.c.example.com
```

