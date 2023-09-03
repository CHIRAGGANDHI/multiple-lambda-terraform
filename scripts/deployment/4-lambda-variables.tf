# Lambda function s3 bucket name
variable "lambda_s3bucketname" {
  description = "Lambda S3 Bucket"
  type = string
}

# Lambda function code zip folder name
variable "lambda_s3key" {
  description = "Lambda code zip folder name"
  type = string
}

# Lambda function source code location
variable "lambda_sourcecode" {
  description = "Lambda source code location"
  type = string
}

variable "lambda_functionname" {
  description = "Lambda function name"
  type = string
}

variable "lambda_function_description" {
  description = "Lambda function name"
  type = string
}