# Get my IP
data "http" "icanhazip" {
  url = "http://icanhazip.com"
}

module "sg_prod_east" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.18.0"

  name            = "mgmt"
  use_name_prefix = false
  description     = "Managed by Terraform"
  vpc_id          = module.vpc_prod_east.vpc_id

  ingress_cidr_blocks = ["${chomp(data.http.icanhazip.body)}/32", "10.0.0.0/8"]
  ingress_rules       = ["ssh-tcp", "rdp-tcp", "all-icmp"]

  egress_cidr_blocks      = ["0.0.0.0/0"]
  egress_ipv6_cidr_blocks = ["::/0"]
  egress_rules            = ["all-all"]

  tags = {
    Environment     = "prod"
    Contact         = var.tag_cont
    Cost            = var.tag_cost
    Customer        = var.tag_cust
    Project         = var.tag_proj
    Confidentiality = var.tag_conf
    Compliance      = var.tag_comp
    Terraform       = "true"
    Packer          = "true"
  }
}

module "sg_prod_west" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.18.0"
  providers = {
    aws = aws.prod_west
  }

  name            = "mgmt"
  use_name_prefix = false
  description     = "Managed by Terraform"
  vpc_id          = module.vpc_prod_west.vpc_id

  ingress_cidr_blocks = ["${chomp(data.http.icanhazip.body)}/32", "10.0.0.0/8"]
  ingress_rules       = ["ssh-tcp", "rdp-tcp", "all-icmp"]

  egress_cidr_blocks      = ["0.0.0.0/0"]
  egress_ipv6_cidr_blocks = ["::/0"]
  egress_rules            = ["all-all"]

  tags = {
    Environment     = "prod"
    Contact         = var.tag_cont
    Cost            = var.tag_cost
    Customer        = var.tag_cust
    Project         = var.tag_proj
    Confidentiality = var.tag_conf
    Compliance      = var.tag_comp
    Terraform       = "true"
    Packer          = "true"
  }
}

module "sg_dev_east" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.18.0"
  providers = {
    aws = aws.dev
  }

  name            = "mgmt"
  use_name_prefix = false
  description     = "Managed by Terraform"
  vpc_id          = module.vpc_dev_east.vpc_id

  ingress_cidr_blocks = ["${chomp(data.http.icanhazip.body)}/32", "10.0.0.0/8"]
  ingress_rules       = ["ssh-tcp", "rdp-tcp", "all-icmp"]

  egress_cidr_blocks      = ["0.0.0.0/0"]
  egress_ipv6_cidr_blocks = ["::/0"]
  egress_rules            = ["all-all"]

  tags = {
    Environment     = "dev"
    Contact         = var.tag_cont
    Cost            = var.tag_cost
    Customer        = var.tag_cust
    Project         = var.tag_proj
    Confidentiality = var.tag_conf
    Compliance      = var.tag_comp
    Terraform       = "true"
    Packer          = "true"
  }
}
