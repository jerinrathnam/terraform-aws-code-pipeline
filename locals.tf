
######################## LOCALS #########################

locals {
  account_id = data.aws_caller_identity.this.account_id
  region     = data.aws_region.this.name
  s3_bucket  = var.s3_bucket_name
}

################# DATA SOURCES #########################

data "aws_caller_identity" "this" {}

data "aws_region" "this" {}