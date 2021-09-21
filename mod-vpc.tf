module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.7.0"

  name                               = var.vpc_name
  cidr                               = var.vpc_cidr
  enable_nat_gateway                 = var.vpc_enable_nat_gateway
  single_nat_gateway                 = var.vpc_single_nat_gateway
  enable_dns_hostnames               = var.vpc_enable_dns_hostnames
  enable_dns_support                 = var.vpc_enable_dns_support
  azs                                = var.vpc_azs
  public_subnets                     = var.vpc_public_subnets
  private_subnets                    = var.vpc_private_subnets
  database_subnets                   = var.vpc_database_subnets
  create_database_subnet_group       = var.vpc_create_database_subnet_group
  create_database_subnet_route_table = var.vpc_create_database_subnet_route_table
  database_subnet_group_name         = var.vpc_database_subnet_group_name
  database_subnet_tags               = var.vpc_database_subnet_tags
  private_subnet_tags                = var.vpc_private_subnet_tags
  public_subnet_tags                 = var.vpc_public_subnet_tags
  one_nat_gateway_per_az             = var.vpc_one_nat_gateway_per_az
  tags                               = var.vpc_tags

}
