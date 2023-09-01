resource "aws_iam_role" "lambda_role" {
  name   = "${local.name}-lambda-role"
  description = "Lambda function role"
  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Action = "sts:AssumeRole"
          Principal = {
            Service = "lambda.amazonaws.com"
          },
          Effect =  "Allow"
          Sid =  ""
        }
      ]
    }) 
}

resource "aws_iam_policy" "lambda_iam_policy_for_cloudwatch" { 
  name         = "${local.name}-cloudwatch-policy"
  path         = "/"
  description  = "AWS IAM Policy for logging"
  policy = jsonencode(
  {
    Version = "2012-10-17"
    Statement =  [
        {
          Action = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents",
            "logs:TagResource"
          ]
          Resource = "arn:aws:logs:*:*:*"
          Effect =  "Allow"
        }
      ]
  })
}

resource "aws_iam_policy" "lambda_iam_policy_for_parameterstore" { 
  name         = "${local.name}-parameterstore-policy"
  path         = "/"
  description  = "AWS IAM Policy for parameterstore"
  policy = jsonencode(
  {
    Version = "2012-10-17"
    Statement = [
        {
          Action = [
            "ssm:Describe*",
            "ssm:Get*",
            "ssm:List*"
          ]
          Resource = "*",
          Effect = "Allow"
        }
      ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_cloudwatch_policy_to_lambda_role" {
 role        = aws_iam_role.lambda_role.name
 policy_arn  = aws_iam_policy.lambda_iam_policy_for_cloudwatch.arn
}

resource "aws_iam_role_policy_attachment" "attach_parameterstore_policy_to_lambda_role" {
 role        = aws_iam_role.lambda_role.name
 policy_arn  = aws_iam_policy.lambda_iam_policy_for_parameterstore.arn
}