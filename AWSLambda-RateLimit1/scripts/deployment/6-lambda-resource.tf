locals {
  functionname = "${local.name}-RateLimit1"
}

resource "aws_lambda_function" "lambda_function" {
    function_name   = local.functionname
    description     = "A Sample Cron Job Function RateLimit1"

    s3_bucket       = var.lambda-s3bucketname
    s3_key          = var.lambda-s3codefolder

    role            = aws_iam_role.lambda_role.arn

    handler         = "handler.run"
    runtime         = "python3.9"

    depends_on      = [
      aws_iam_role_policy_attachment.attach_cloudwatch_policy_to_lambda_role, 
      aws_iam_role_policy_attachment.attach_parameterstore_policy_to_lambda_role]

    timeout         = 6  //seconds
    memory_size     = 128  //MB
    publish         = true //version

    layers = [
      "arn:aws:lambda:ap-south-1:176022468876:layer:AWS-Parameters-and-Secrets-Lambda-Extension:10",
      "arn:aws:lambda:ap-south-1:898466741470:layer:psycopg2-py37:1" ]

    environment {
      variables = {
        AWS_PARAMETER_SPACE = "${local.parameterstoreprefix}/aws-db-pgsql/dbConnectionString/dbname"
        AWS_LAMBDA_REGION = var.aws_region
      }    
    }

    tags = local.common_tags
}

resource "aws_cloudwatch_event_rule" "lambda_event_rule" {
  name = "${local.functionname}-event-rule"
  description = "Retry scheduled every 1 min"
  schedule_expression = "cron(*/1 * * * ? *)"

  tags = local.common_tags
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  arn = aws_lambda_function.lambda_function.arn
  rule = aws_cloudwatch_event_rule.lambda_event_rule.name
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_rw_fallout_retry_step_deletion_lambda" {
  statement_id = "AllowExecutionFromCloudWatch"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.lambda_event_rule.arn
}