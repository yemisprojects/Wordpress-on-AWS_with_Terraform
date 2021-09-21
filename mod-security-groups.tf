module "bastion_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.3.0"

  name        = "bastion_sg"
  description = "Security group to access the bastion_host"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      rule        = "ssh-tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      rule        = "http-80-tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_with_cidr_blocks = [
    {
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

}

module "alb_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.3.0"

  name        = "alb_sg"
  description = "Security group to access the application load balancer"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      rule        = "http-80-tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      rule        = "https-443-tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_with_cidr_blocks = [
    {
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

}

module "private_webserver_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.3.0"

  name        = "private_webserver_sg"
  description = "Security group to access the application/webservers"
  vpc_id      = module.vpc.vpc_id

  number_of_computed_ingress_with_source_security_group_id = 2
  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = module.alb_sg.security_group_id
    },
    {
      from_port                = 22
      to_port                  = 22
      protocol                 = 6
      description              = "allow ssh from bastion"
      source_security_group_id = module.bastion_sg.security_group_id
    }
  ]

  egress_with_cidr_blocks = [
    {
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

}

module "database_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.3.0"

  name        = "database_sg"
  description = "Security group to access the database"
  vpc_id      = module.vpc.vpc_id

  number_of_computed_ingress_with_source_security_group_id = 1
  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp"
      source_security_group_id = module.private_webserver_sg.security_group_id
    }
  ]

  egress_with_cidr_blocks = [
    {
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

}

module "efs_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.3.0"

  name        = "efs_sg"
  description = "Security group to access EFS filesystem"
  vpc_id      = module.vpc.vpc_id

  number_of_computed_ingress_with_source_security_group_id = 1
  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "nfs-tcp"
      source_security_group_id = module.private_webserver_sg.security_group_id
    }
  ]

  egress_with_cidr_blocks = [
    {
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}