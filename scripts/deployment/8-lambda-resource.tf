resource "aws_lambda_function" "lambda_function" {
    function_name     = local.functionname
    description       = var.lambda_function_description    

    s3_bucket         = data.aws_s3_bucket.lambda_bucket.id
    s3_key            = var.lambda_s3key
    //source_code_hash  = data.archive_file.lambda_code.output_base64sha256

    role              = aws_iam_role.lambda_role.arn

    handler           = "handler.run"
    runtime           = "python3.9"

    depends_on        = [
      aws_iam_role_policy_attachment.attach_cloudwatch_policy_to_lambda_role, 
      aws_iam_role_policy_attachment.attach_parameterstore_policy_to_lambda_role,
      aws_iam_role_policy_attachment.attach_vpc_policy_to_lambda_role,
      aws_cloudwatch_log_group.lambda_function_log_group ]

    timeout           = 6  //seconds
    memory_size       = 128  //MB
    publish           = true //version

    vpc_config {
      subnet_ids         = [
        data.terraform_remote_state.vpc-infrastructure.outputs.private_subnets[3], 
        data.terraform_remote_state.vpc-infrastructure.outputs.private_subnets[4] ]

      security_group_ids = [
        data.terraform_remote_state.vpc-infrastructure.outputs.lambda_sg_group_id ]
    }

    layers = [
      "arn:aws:lambda:ap-south-1:176022468876:layer:AWS-Parameters-and-Secrets-Lambda-Extension:10",
      "arn:aws:lambda:ap-south-1:898466741470:layer:psycopg2-py37:1" ]

    environment {
      variables = {
        AWS_PARAMETER_BUSINESS_DIVISION = local.owners
        AWS_PARAMETER_SPACE = local.space
        AWS_PARAMETER_ENVIRONMENT = local.environment
        AWS_LAMBDA_REGION = var.aws_region
      }    
    }

    tags = local.common_tags
}

resource "aws_cloudwatch_log_group" "lambda_function_log_group" {
  name = "/aws/lambda/${local.functionname}"  
  retention_in_days = 30

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