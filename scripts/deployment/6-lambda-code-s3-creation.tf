/*resource "random_pet" "lambda_bucket_name" {
  prefix = var.lambda-s3bucketname
  length = 4
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = random_pet.lambda_bucket_name.id   
  force_destroy = true
}

resource "aws_s3_bucket_acl" "lambda_bucket_acl" {
  bucket = aws_s3_bucket.lambda_bucket.id
  acl    = "private"
}*/

data "archive_file" "lambda_code" {
  type = "zip"

  source_dir  = "${path.module}/../../${var.lambda_sourcecode}"
  output_path = "${path.module}/../../${var.lambda_s3key}.zip"
}

resource "aws_s3_object" "lambda_code" {
  bucket = data.aws_s3_bucket.lambda_bucket.id

  key    = "${var.lambda_s3key}.zip"
  source = data.archive_file.lambda_code.output_path

  etag = filemd5(data.archive_file.lambda_code.output_path)
}