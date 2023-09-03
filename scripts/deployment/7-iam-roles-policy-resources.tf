resource "aws_iam_role" "lambda_role" {
  name   = "${local.functionname}-lambda-role"
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
  name         = "${local.functionname}-cloudwatch-policy"
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
  name         = "${local.functionname}-parameterstore-policy"
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

resource "aws_iam_policy" "lambda_iam_policy_for_vpc" { 
  name         = "${local.functionname}-vpc-policy"
  path         = "/"
  description  = "AWS IAM Policy for VPC"
  policy = jsonencode(
  {
    Version = "2012-10-17"
    Statement = [
        {
          Action = [
            "ec2:DescribeInstances",
            "ec2:CreateNetworkInterface",
            "ec2:AttachNetworkInterface",
            "ec2:DescribeNetworkInterfaces",
            "autoscaling:CompleteLifecycleAction",
            "ec2:DeleteNetworkInterface"
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

resource "aws_iam_role_policy_attachment" "attach_vpc_policy_to_lambda_role" {
 role        = aws_iam_role.lambda_role.name
 policy_arn  = aws_iam_policy.lambda_iam_policy_for_vpc.arn
}