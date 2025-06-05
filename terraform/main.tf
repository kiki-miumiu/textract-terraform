# S3 bucket for Lambda deployment package
resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "terraform-lambda-${data.aws_caller_identity.current.account_id}"
}

# Archive the Lambda function source code
data "archive_file" "lambda_hello_world" {
  type = "zip"

  source_dir  = "${path.module}/src/hello-world"
  output_path = "${path.module}/src/hello-world.zip"
}

# Upload the Lambda deployment package to S3
resource "aws_s3_object" "lambda_hello_world" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "hello-world.zip"
  source = data.archive_file.lambda_hello_world.output_path

  etag = filemd5(data.archive_file.lambda_hello_world.output_path)
}

# Create the Lambda function using the deployment package in S3
resource "aws_lambda_function" "hello_world" {
  function_name = "HelloWorld"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.lambda_hello_world.key

  runtime = "python3.11"
  handler = "app.lambda_handler"

  source_code_hash = data.archive_file.lambda_hello_world.output_base64sha256

  role = aws_iam_role.lambda_exec.arn
}

# Create a CloudWatch log group for the Lambda function
resource "aws_cloudwatch_log_group" "hello_world" {
  name = "/aws/lambda/${aws_lambda_function.hello_world.function_name}"

  retention_in_days = 30
}

# IAM role for Lambda execution
resource "aws_iam_role" "lambda_exec" {
  name = "serverless_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

# Attach the AWSLambdaBasicExecutionRole policy to the Lambda execution role
resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}