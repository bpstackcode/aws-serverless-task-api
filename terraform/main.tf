terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# DynamoDB Table
resource "aws_dynamodb_table" "tasks" {
  name         = "tasks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "task_id"

  attribute {
    name = "task_id"
    type = "S"
  }
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "serverless-task-lambda-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_dynamodb" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
# Lambda zip packages
data "archive_file" "create_task" {
  type        = "zip"
  source_file = "${path.module}/../lambdas/create_task/lambda_function.py"
  output_path = "${path.module}/../lambdas/create_task/lambda_function.zip"
}

data "archive_file" "get_tasks" {
  type        = "zip"
  source_file = "${path.module}/../lambdas/get_tasks/lambda_function.py"
  output_path = "${path.module}/../lambdas/get_tasks/lambda_function.zip"
}

data "archive_file" "update_task" {
  type        = "zip"
  source_file = "${path.module}/../lambdas/update_task/lambda_function.py"
  output_path = "${path.module}/../lambdas/update_task/lambda_function.zip"
}

data "archive_file" "delete_task" {
  type        = "zip"
  source_file = "${path.module}/../lambdas/delete_task/lambda_function.py"
  output_path = "${path.module}/../lambdas/delete_task/lambda_function.zip"
}

# Lambda Functions
resource "aws_lambda_function" "create_task" {
  filename         = data.archive_file.create_task.output_path
  function_name    = "create-task"
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.12"
  source_code_hash = data.archive_file.create_task.output_base64sha256
}

resource "aws_lambda_function" "get_tasks" {
  filename         = data.archive_file.get_tasks.output_path
  function_name    = "get-tasks"
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.12"
  source_code_hash = data.archive_file.get_tasks.output_base64sha256
}

resource "aws_lambda_function" "update_task" {
  filename         = data.archive_file.update_task.output_path
  function_name    = "update-task"
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.12"
  source_code_hash = data.archive_file.update_task.output_base64sha256
}

resource "aws_lambda_function" "delete_task" {
  filename         = data.archive_file.delete_task.output_path
  function_name    = "delete-task"
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.12"
  source_code_hash = data.archive_file.delete_task.output_base64sha256
}

# API Gateway
resource "aws_api_gateway_rest_api" "task_api" {
  name        = "serverless-task-api"
  description = "Serverless Task Management API"
}
