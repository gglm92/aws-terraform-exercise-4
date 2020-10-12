provider "aws" {
  version    = "~> 3.0"
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

provider "aws" {
  version    = "~> 3.0"
  alias = "west"
  region     = var.replication_aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}