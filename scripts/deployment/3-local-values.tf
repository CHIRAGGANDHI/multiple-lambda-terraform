locals {
  owners = var.business_divsion
  space = var.space
  environment = var.environment  

  name = "${local.owners}-${local.space}-${local.environment}"

  functionname = "${local.name}-${var.lambda_functionname}"

  common_tags = {
    owners = local.owners
    space = local.space
    environment = local.environment    
  }
}