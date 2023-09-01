variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type = string
  default = "ap-south-1"
}

# Business Division
variable "business_divsion" {
  description = "Business Division in the large organization this Infrastructure belongs"
  type = string
  default = "oms"
}

# Team Name
variable "space" {
  description = "Setting up team name"
  type = string
  default = "theoldmonks"
}

# Environment Variable
variable "environment" {
  description = "Environment Variable used as a prefix"
  type = string
  default = "dev"
}

variable "aws_accesskey" {
  type = string
}

variable "aws_secret_key" {
  type = string
}