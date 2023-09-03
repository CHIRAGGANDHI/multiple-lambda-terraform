output "function_name" {
  description = "Name of the Lambda function."
  value = aws_lambda_function.lambda_function.function_name
}

output "function_arn" {
  description = "Lambda function ARN"
  value = aws_lambda_function.lambda_function.arn
}

output "eventbridge_name" {
  description = "EventBridge Name"
  value = aws_cloudwatch_event_rule.lambda_event_rule.name
}

output "eventbridge_arn" {
  description = "EventBridge ARN"
  value = aws_cloudwatch_event_rule.lambda_event_rule.arn
}
