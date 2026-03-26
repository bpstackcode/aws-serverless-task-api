output "dynamodb_table_name" {
  description = "DynamoDB table name"
  value       = aws_dynamodb_table.tasks.name
}

output "lambda_role_arn" {
  description = "IAM role ARN for Lambda functions"
  value       = aws_iam_role.lambda_role.arn
}

output "api_gateway_url" {
  description = "API Gateway invoke URL"
  value       = "https://${aws_api_gateway_rest_api.task_api.id}.execute-api.${var.aws_region}.amazonaws.com/prod"
}
