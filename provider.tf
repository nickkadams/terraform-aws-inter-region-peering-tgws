provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}

provider "aws" {
  alias  = "prod_west"
  region = "us-west-2"
}

provider "aws" {
  alias  = "dev"
  region = var.aws_region

  assume_role {
    role_arn = "arn:aws:iam::${var.aws_assume_account_dev}:role/${var.aws_assume_role}"
  }
}

provider "aws" {
  alias  = "tgw_east"
  region = var.aws_region

  assume_role {
    role_arn = "arn:aws:iam::${var.aws_assume_account_tgw}:role/${var.aws_assume_role}"
  }
}

provider "aws" {
  alias  = "tgw_west"
  region = "us-west-2"

  assume_role {
    role_arn = "arn:aws:iam::${var.aws_assume_account_tgw}:role/${var.aws_assume_role}"
  }
}