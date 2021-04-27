data "aws_availability_zones" "available" {}

data "aws_caller_identity" "current" {}

module "vpc_prod_east" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.78.0"

  name = "prod"

  cidr = "10.0.0.0/16"

  # 3-AZs
  azs             = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1], data.aws_availability_zones.available.names[2]]
  public_subnets  = ["10.0.0.0/19", "10.0.64.0/19", "10.0.128.0/19"]
  private_subnets = ["10.0.32.0/19", "10.0.96.0/19", "10.0.160.0/19"]

  # IPv6
  enable_ipv6                     = false
  assign_ipv6_address_on_creation = false

  # NAT/VPN
  enable_nat_gateway = false
  single_nat_gateway = false
  enable_vpn_gateway = false

  # DNS options
  enable_dns_hostnames             = true
  enable_dns_support               = true
  enable_dhcp_options              = true
  dhcp_options_domain_name_servers = ["AmazonProvidedDNS"]

  # Gateway endpoint for S3
  enable_s3_endpoint = true

  # Gateway endpoint for DynamoDB
  enable_dynamodb_endpoint = true

  # Default security group - ingress/egress rules cleared to deny all
  manage_default_security_group  = true
  default_security_group_ingress = []
  default_security_group_egress  = []

  tags = {
    Environment     = "prod"
    Contact         = var.tag_cont
    Cost            = var.tag_cost
    Customer        = var.tag_cust
    Project         = var.tag_proj
    Confidentiality = var.tag_conf
    Compliance      = var.tag_comp
    Terraform       = "true"
  }

  default_security_group_tags = {
    Name = "prod-default"
  }

  private_subnet_tags = {
    Tier = "private"
  }

  public_subnet_tags = {
    Tier = "public"
  }

  vpc_endpoint_tags = {
    Name = "prod"
  }
}

resource "aws_db_subnet_group" "prod_east" {
  name       = "prod"
  subnet_ids = [module.vpc_prod_east.private_subnets[0], module.vpc_prod_east.private_subnets[1], module.vpc_prod_east.private_subnets[2]]

  tags = {
    Environment     = "prod"
    Contact         = var.tag_cont
    Cost            = var.tag_cost
    Customer        = var.tag_cust
    Project         = var.tag_proj
    Confidentiality = var.tag_conf
    Compliance      = var.tag_comp
    Terraform       = "true"
    Tier            = "private"
  }
}

resource "aws_elasticache_subnet_group" "prod_east" {
  name       = "prod"
  subnet_ids = [module.vpc_prod_east.private_subnets[0], module.vpc_prod_east.private_subnets[1], module.vpc_prod_east.private_subnets[2]]
}

###

module "vpc_prod_west" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.78.0"
  providers = {
    aws = aws.prod_west
  }

  name = "prod"

  cidr = "10.1.0.0/16"

  # 3-AZs
  azs             = ["us-west-2a", "us-west-2b", "us-west-2c"]
  public_subnets  = ["10.1.0.0/19", "10.1.64.0/19", "10.1.128.0/19"]
  private_subnets = ["10.1.32.0/19", "10.1.96.0/19", "10.1.160.0/19"]

  # IPv6
  enable_ipv6                     = false
  assign_ipv6_address_on_creation = false

  # NAT/VPN
  enable_nat_gateway = false
  single_nat_gateway = false
  enable_vpn_gateway = false

  # DNS options
  enable_dns_hostnames             = true
  enable_dns_support               = true
  enable_dhcp_options              = true
  dhcp_options_domain_name_servers = ["AmazonProvidedDNS"]

  # Gateway endpoint for S3
  enable_s3_endpoint = true

  # Gateway endpoint for DynamoDB
  enable_dynamodb_endpoint = true

  # Default security group - ingress/egress rules cleared to deny all
  manage_default_security_group  = true
  default_security_group_ingress = []
  default_security_group_egress  = []

  tags = {
    Environment     = "prod"
    Contact         = var.tag_cont
    Cost            = var.tag_cost
    Customer        = var.tag_cust
    Project         = var.tag_proj
    Confidentiality = var.tag_conf
    Compliance      = var.tag_comp
    Terraform       = "true"
  }

  default_security_group_tags = {
    Name = "prod-default"
  }

  private_subnet_tags = {
    Tier = "private"
  }

  public_subnet_tags = {
    Tier = "public"
  }

  vpc_endpoint_tags = {
    Name = "prod"
  }
}

resource "aws_db_subnet_group" "prod_west" {
  provider   = aws.prod_west
  name       = "prod"
  subnet_ids = [module.vpc_prod_west.private_subnets[0], module.vpc_prod_west.private_subnets[1], module.vpc_prod_west.private_subnets[2]]

  tags = {
    Environment     = "prod"
    Contact         = var.tag_cont
    Cost            = var.tag_cost
    Customer        = var.tag_cust
    Project         = var.tag_proj
    Confidentiality = var.tag_conf
    Compliance      = var.tag_comp
    Terraform       = "true"
    Tier            = "private"
  }
}

resource "aws_elasticache_subnet_group" "prod_west" {
  provider   = aws.prod_west
  name       = "prod"
  subnet_ids = [module.vpc_prod_west.private_subnets[0], module.vpc_prod_west.private_subnets[1], module.vpc_prod_west.private_subnets[2]]
}


###

module "vpc_dev_east" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.78.0"
  providers = {
    aws = aws.dev
  }

  name = "dev"

  cidr = "10.10.0.0/16"

  # 3-AZs
  azs             = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1], data.aws_availability_zones.available.names[2]]
  public_subnets  = ["10.10.0.0/19", "10.10.64.0/19", "10.10.128.0/19"]
  private_subnets = ["10.10.32.0/19", "10.10.96.0/19", "10.10.160.0/19"]

  # IPv6
  enable_ipv6                     = false
  assign_ipv6_address_on_creation = false

  # NAT/VPN
  enable_nat_gateway = false
  single_nat_gateway = false
  enable_vpn_gateway = false

  # DNS options
  enable_dns_hostnames             = true
  enable_dns_support               = true
  enable_dhcp_options              = true
  dhcp_options_domain_name_servers = ["AmazonProvidedDNS"]

  # Gateway endpoint for S3
  enable_s3_endpoint = true

  # Gateway endpoint for DynamoDB
  enable_dynamodb_endpoint = true

  # Default security group - ingress/egress rules cleared to deny all
  manage_default_security_group  = true
  default_security_group_ingress = []
  default_security_group_egress  = []

  tags = {
    Environment     = "dev"
    Contact         = var.tag_cont
    Cost            = var.tag_cost
    Customer        = var.tag_cust
    Project         = var.tag_proj
    Confidentiality = var.tag_conf
    Compliance      = var.tag_comp
    Terraform       = "true"
  }

  default_security_group_tags = {
    Name = "dev-default"
  }

  private_subnet_tags = {
    Tier = "private"
  }

  public_subnet_tags = {
    Tier = "public"
  }

  vpc_endpoint_tags = {
    Name = "dev"
  }
}

resource "aws_db_subnet_group" "dev_east" {
  provider   = aws.dev
  name       = "dev"
  subnet_ids = [module.vpc_dev_east.private_subnets[0], module.vpc_dev_east.private_subnets[1], module.vpc_dev_east.private_subnets[2]]

  tags = {
    Environment     = "dev"
    Contact         = var.tag_cont
    Cost            = var.tag_cost
    Customer        = var.tag_cust
    Project         = var.tag_proj
    Confidentiality = var.tag_conf
    Compliance      = var.tag_comp
    Terraform       = "true"
    Tier            = "private"
  }
}

resource "aws_elasticache_subnet_group" "dev_east" {
  provider   = aws.dev
  name       = "dev"
  subnet_ids = [module.vpc_dev_east.private_subnets[0], module.vpc_dev_east.private_subnets[1], module.vpc_dev_east.private_subnets[2]]
}