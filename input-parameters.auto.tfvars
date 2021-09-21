#############REQUIRED#######################
route53_public_zone_name = "example.com"
#############REQUIRED#######################

region                     = "ca-central-1"
vpc_name                   = "WordPress"
vpc_cidr = "10.0.0.0/16"
vpc_public_subnets         = ["10.0.1.0/24", "10.0.2.0/24"]
vpc_private_subnets         = ["10.0.3.0/24", "10.0.4.0/24"]
vpc_database_subnets       = ["10.0.5.0/24", "10.0.6.0/24"]
vpc_azs                    = ["ca-central-1a", "ca-central-1b"]
vpc_enable_nat_gateway     = true
vpc_single_nat_gateway     = false
vpc_one_nat_gateway_per_az = true
generated_key_name         = "terraform-key-pair"
db_ismulti_az              = true
dbinstance_class           = "db.t2.micro"
dbname                     = "wordpressdb"
dbusername                 = "dbusername"
dbpassword                 = "dbpassword"



