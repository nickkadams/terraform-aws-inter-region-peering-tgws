# Transit Gateway in us-east-1
resource "aws_ec2_transit_gateway" "tgw_east" {
  provider                        = aws.tgw_east
  description                     = "Managed by Terraform"
  amazon_side_asn                 = 65432
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  auto_accept_shared_attachments  = "enable"
  vpn_ecmp_support                = "enable"
  dns_support                     = "enable"

  tags = {
    Name            = "tgw"
    Environment     = "tgw"
    Contact         = var.tag_cont
    Cost            = var.tag_cost
    Customer        = var.tag_cust
    Project         = var.tag_proj
    Confidentiality = "private"
    Compliance      = var.tag_comp
    Terraform       = "true"
  }
}

# Transit Gateway in us-west-2
resource "aws_ec2_transit_gateway" "tgw_west" {
  provider                        = aws.tgw_west
  description                     = "Managed by Terraform"
  amazon_side_asn                 = 65431
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  auto_accept_shared_attachments  = "enable"
  vpn_ecmp_support                = "enable"
  dns_support                     = "enable"

  tags = {
    Name            = "tgw"
    Environment     = "tgw"
    Contact         = var.tag_cont
    Cost            = var.tag_cost
    Customer        = var.tag_cust
    Project         = var.tag_proj
    Confidentiality = "private"
    Compliance      = var.tag_comp
    Terraform       = "true"
  }
}

# Share Transit Gateway us-east-1
resource "aws_ram_resource_share" "tgw_east" {
  provider                  = aws.tgw_east
  name                      = "tgw"
  allow_external_principals = true

  tags = {
    Environment     = "tgw"
    Contact         = var.tag_cont
    Cost            = var.tag_cost
    Customer        = var.tag_cust
    Project         = var.tag_proj
    Confidentiality = "private"
    Compliance      = var.tag_comp
    Terraform       = "true"
  }
}

# RAM share East Transit Gateway
resource "aws_ram_resource_association" "tgw_east" {
  provider           = aws.tgw_east
  resource_arn       = aws_ec2_transit_gateway.tgw_east.arn
  resource_share_arn = aws_ram_resource_share.tgw_east.id
}

# RAM share East Transit Gateway to Prod East
resource "aws_ram_principal_association" "to_prod_east" {
  provider           = aws.tgw_east
  principal          = data.aws_caller_identity.current.account_id
  resource_share_arn = aws_ram_resource_share.tgw_east.arn
}

# RAM share East Transit Gateway to Dev East
resource "aws_ram_principal_association" "to_dev_east" {
  provider           = aws.tgw_east
  principal          = var.aws_assume_account_dev
  resource_share_arn = aws_ram_resource_share.tgw_east.arn
}

# Share Transit Gateway us-west-2
resource "aws_ram_resource_share" "tgw_west" {
  provider                  = aws.tgw_west
  name                      = "tgw"
  allow_external_principals = true

  tags = {
    Environment     = "tgw"
    Contact         = var.tag_cont
    Cost            = var.tag_cost
    Customer        = var.tag_cust
    Project         = var.tag_proj
    Confidentiality = "private"
    Compliance      = var.tag_comp
    Terraform       = "true"
  }
}

# RAM share West Transit Gateway
resource "aws_ram_resource_association" "tgw_west" {
  provider           = aws.tgw_west
  resource_arn       = aws_ec2_transit_gateway.tgw_west.arn
  resource_share_arn = aws_ram_resource_share.tgw_west.id
}

# RAM share East Transit Gateway to Prod West
resource "aws_ram_principal_association" "to_prod_west" {
  provider           = aws.tgw_west
  principal          = data.aws_caller_identity.current.account_id
  resource_share_arn = aws_ram_resource_share.tgw_west.arn
}

# East to West Transit Gateway Attachment - Peering Connection
# Manual accept attachment in us-west-2
resource "aws_ec2_transit_gateway_peering_attachment" "tgw_peer" {
  provider                = aws.tgw_east
  peer_account_id         = aws_ec2_transit_gateway.tgw_west.owner_id
  peer_region             = "us-west-2"
  peer_transit_gateway_id = aws_ec2_transit_gateway.tgw_west.id
  transit_gateway_id      = aws_ec2_transit_gateway.tgw_east.id

  tags = {
    Name            = "east-to-west-peer"
    Environment     = "tgw"
    Contact         = var.tag_cont
    Cost            = var.tag_cost
    Customer        = var.tag_cust
    Project         = var.tag_proj
    Confidentiality = "private"
    Compliance      = var.tag_comp
    Terraform       = "true"
  }
}

# Prod East Transit Gateway Attachment - VPC
resource "aws_ec2_transit_gateway_vpc_attachment" "prod_east" {
  transit_gateway_id                              = aws_ec2_transit_gateway.tgw_east.id
  vpc_id                                          = module.vpc_prod_east.vpc_id
  subnet_ids                                      = module.vpc_prod_east.public_subnets
  dns_support                                     = "enable"
  ipv6_support                                    = "disable"
  transit_gateway_default_route_table_association = "false"
  transit_gateway_default_route_table_propagation = "false"

  tags = {
    Name            = "prod-to-tgw"
    Environment     = "prod"
    Contact         = var.tag_cont
    Cost            = var.tag_cost
    Customer        = var.tag_cust
    Project         = var.tag_proj
    Confidentiality = "private"
    Compliance      = var.tag_comp
    Terraform       = "true"
  }
}

# Dev East Transit Gateway Attachment - VPC
resource "aws_ec2_transit_gateway_vpc_attachment" "dev_east" {
  provider                                        = aws.dev
  transit_gateway_id                              = aws_ec2_transit_gateway.tgw_east.id
  vpc_id                                          = module.vpc_dev_east.vpc_id
  subnet_ids                                      = module.vpc_dev_east.public_subnets
  dns_support                                     = "enable"
  ipv6_support                                    = "disable"
  transit_gateway_default_route_table_association = "false"
  transit_gateway_default_route_table_propagation = "false"

  tags = {
    Name            = "dev-to-tgw"
    Environment     = "dev"
    Contact         = var.tag_cont
    Cost            = var.tag_cost
    Customer        = var.tag_cust
    Project         = var.tag_proj
    Confidentiality = "private"
    Compliance      = var.tag_comp
    Terraform       = "true"
  }
}

# Prod East Transit Gateway Attachment - VPC
resource "aws_ec2_transit_gateway_vpc_attachment" "prod_west" {
  provider                                        = aws.prod_west
  transit_gateway_id                              = aws_ec2_transit_gateway.tgw_west.id
  vpc_id                                          = module.vpc_prod_west.vpc_id
  subnet_ids                                      = module.vpc_prod_west.public_subnets
  dns_support                                     = "enable"
  ipv6_support                                    = "disable"
  transit_gateway_default_route_table_association = "false"
  transit_gateway_default_route_table_propagation = "false"

  tags = {
    Name            = "prod-to-tgw"
    Environment     = "prod"
    Contact         = var.tag_cont
    Cost            = var.tag_cost
    Customer        = var.tag_cust
    Project         = var.tag_proj
    Confidentiality = "private"
    Compliance      = var.tag_comp
    Terraform       = "true"
  }
}

# Transit Gateway Route Table in us-east-1
resource "aws_ec2_transit_gateway_route_table" "tgw_east" {
  provider           = aws.tgw_east
  transit_gateway_id = aws_ec2_transit_gateway.tgw_east.id
  # default_association_route_table = "disable"
  # default_propagation_route_table = "disable"

  tags = {
    Name            = "tgw"
    Environment     = "tgw"
    Contact         = var.tag_cont
    Cost            = var.tag_cost
    Customer        = var.tag_cust
    Project         = var.tag_proj
    Confidentiality = "private"
    Compliance      = var.tag_comp
    Terraform       = "true"
  }
}

# Associate Prod in us-east-1
resource "aws_ec2_transit_gateway_route_table_association" "prod_east" {
  provider                       = aws.tgw_east
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.prod_east.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_east.id
}

# Propagate Prod in us-east-1
resource "aws_ec2_transit_gateway_route_table_propagation" "prod_east" {
  provider                       = aws.tgw_east
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.prod_east.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_east.id
}

# Associate Dev in us-east-1
resource "aws_ec2_transit_gateway_route_table_association" "dev_east" {
  provider                       = aws.tgw_east
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.dev_east.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_east.id
}

# Propagate Dev in us-east-1
resource "aws_ec2_transit_gateway_route_table_propagation" "dev_east" {
  provider                       = aws.tgw_east
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.dev_east.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_east.id
}

# Associate Peer in us-east-1
resource "aws_ec2_transit_gateway_route_table_association" "east_to_west" {
  provider                       = aws.tgw_east
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.tgw_peer.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_east.id
}

# Static route for Peer in us-east-1
resource "aws_ec2_transit_gateway_route" "east_to_west" {
  provider                       = aws.tgw_east
  destination_cidr_block         = "10.1.0.0/16"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.tgw_peer.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_east.id
}

# Transit Gateway Route Table in us-west-2
resource "aws_ec2_transit_gateway_route_table" "tgw_west" {
  provider           = aws.tgw_west
  transit_gateway_id = aws_ec2_transit_gateway.tgw_west.id
  # default_association_route_table = "disable"
  # default_propagation_route_table = "disable"
  tags = {
    Name            = "tgw"
    Environment     = "tgw"
    Contact         = var.tag_cont
    Cost            = var.tag_cost
    Customer        = var.tag_cust
    Project         = var.tag_proj
    Confidentiality = "private"
    Compliance      = var.tag_comp
    Terraform       = "true"
  }
}

# Associate Prod in us-west-2
resource "aws_ec2_transit_gateway_route_table_association" "prod_west" {
  provider                       = aws.tgw_west
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.prod_west.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_west.id
}

# Propagate Prod in us-west-2
resource "aws_ec2_transit_gateway_route_table_propagation" "prod_west" {
  provider                       = aws.tgw_west
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.prod_west.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_west.id
}

# Associate Peer in us-west-2
resource "aws_ec2_transit_gateway_route_table_association" "west_to_east" {
  provider                       = aws.tgw_west
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.tgw_peer.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_west.id
}

# Static route for Peer in us-west-2
resource "aws_ec2_transit_gateway_route" "west_to_east_zero" {
  provider                       = aws.tgw_west
  destination_cidr_block         = "10.0.0.0/16"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.tgw_peer.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_west.id
}

# Static route for Peer in us-west-2
resource "aws_ec2_transit_gateway_route" "west_to_east_ten" {
  provider                       = aws.tgw_west
  destination_cidr_block         = "10.10.0.0/16"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.tgw_peer.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_west.id
}

# Update Prod East route table
resource "aws_route" "to_dev_east" {
  route_table_id         = join(" ", module.vpc_prod_east.public_route_table_ids) # tuple to string
  destination_cidr_block = "10.10.0.0/16"
  transit_gateway_id     = aws_ec2_transit_gateway.tgw_east.id
}

resource "aws_route" "to_prod_west" {
  route_table_id         = join(" ", module.vpc_prod_east.public_route_table_ids) # tuple to string
  destination_cidr_block = "10.1.0.0/16"
  transit_gateway_id     = aws_ec2_transit_gateway.tgw_east.id
}

# Update Prod West route table
resource "aws_route" "to_prod_east" {
  provider               = aws.prod_west
  route_table_id         = join(" ", module.vpc_prod_west.public_route_table_ids) # tuple to string
  destination_cidr_block = "10.0.0.0/16"
  transit_gateway_id     = aws_ec2_transit_gateway.tgw_west.id
}

resource "aws_route" "prod_to_dev_east" {
  provider               = aws.prod_west
  route_table_id         = join(" ", module.vpc_prod_west.public_route_table_ids) # tuple to string
  destination_cidr_block = "10.10.0.0/16"
  transit_gateway_id     = aws_ec2_transit_gateway.tgw_west.id
}

# Update Dev East route table
resource "aws_route" "dev_to_prod_east" {
  provider               = aws.dev
  route_table_id         = join(" ", module.vpc_dev_east.public_route_table_ids) # tuple to string
  destination_cidr_block = "10.0.0.0/16"
  transit_gateway_id     = aws_ec2_transit_gateway.tgw_east.id
}

resource "aws_route" "dev_to_prod_west" {
  provider               = aws.dev
  route_table_id         = join(" ", module.vpc_dev_east.public_route_table_ids) # tuple to string
  destination_cidr_block = "10.1.0.0/16"
  transit_gateway_id     = aws_ec2_transit_gateway.tgw_east.id
}