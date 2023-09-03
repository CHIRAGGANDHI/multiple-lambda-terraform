data "terraform_remote_state" "vpc-infrastructure" {
    backend = "s3"
    config = {
      bucket = var.state_bucket
      key = "${local.space}/${local.environment}/vpc/terraform.tfstate"
      region = var.aws_region
    }
}