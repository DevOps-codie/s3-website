//this file creates the lambda for the redirect

data "archive_file" "cdn-origin-request-zip" {
  type        = "zip"
  source_file = "index.js"
  output_path = "cdn-origin-request.zip"
}

# Lambda at Edge requires specific execution role
# in order to be able to execute on CF Edge Location

resource "aws_iam_role_policy" "cdn-lambda-execution" {
  name_prefix = "lambda-execution-policy-"
  role        = aws_iam_role.cdn-lambda-execution.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:CreateLogGroup"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "cdn-lambda-execution" {
  name_prefix        = "lambda-execution-role-"
  description        = "Managed by Terraform"
  assume_role_policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
      {
         "Effect": "Allow",
         "Principal": {
            "Service": [
               "lambda.amazonaws.com",
               "edgelambda.amazonaws.com"
            ]
         },
         "Action": "sts:AssumeRole"
      }
   ]
}
EOF
}

resource "aws_lambda_function" "cdn-origin-request-lambda" {
  filename = "dist/cdn-origin-request.zip"
  function_name = "cdn-origin-request"
  role = aws_iam_role.cdn-lambda-execution.arn
  handler = "handler.handler"
  source_code_hash = data.archive_file.cdn-origin-request-zip.output_base64sha256
  runtime = "nodejs12.x"
}
