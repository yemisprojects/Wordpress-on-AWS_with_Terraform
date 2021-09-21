module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "3.4.0"

  identifier              = var.dbidentifier
  engine                  = "mysql"
  engine_version          = "8.0.25"
  family                  = "mysql8.0" # DB parameter group
  major_engine_version    = "8.0"      # DB option group
  instance_class          = var.dbinstance_class
  create_db_subnet_group  = false
  db_subnet_group_name    = module.vpc.database_subnet_group_name
  allocated_storage       = 20
  max_allocated_storage   = 100
  storage_encrypted       = false
  name                    = var.dbname
  username                = var.dbusername
  password                = var.dbpassword
  port                    = 3306
  multi_az                = var.db_ismulti_az
  subnet_ids              = module.vpc.database_subnets
  vpc_security_group_ids  = [module.database_sg.security_group_id]
  backup_retention_period = 0
  skip_final_snapshot     = true
  deletion_protection     = false

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]

  db_instance_tags = {
    "Sensitive" = "high"
  }
  db_option_group_tags = {
    "Sensitive" = "low"
  }
  db_parameter_group_tags = {
    "Sensitive" = "low"
  }
  db_subnet_group_tags = {
    "Sensitive" = "high"
  }
}



