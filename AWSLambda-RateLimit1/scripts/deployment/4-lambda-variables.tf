# Lambda function s3 bucket name
variable "lambda-s3bucketname" {
  description = "Lambda S3 Bucket"
  type = string
}

# Lambda function code zip folder name
variable "lambda-s3codefolder" {
  description = "Lambda code zip folder name"
  type = string
}