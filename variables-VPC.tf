variable "region" {
  description = "Region where aws operations will be invoked"
  type        = string
  default     = "ca-central-1"
}

variable "vpc_tags" {
  description = " A map of tags to add to all resources"
  type        = map(string)
  default = {
    Owner = "NASA"
  }
}

variable "vpc_name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = "WordPress"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(any)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "vpc_private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(any)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "vpc_database_subnets" {
  description = "A list of database subnets"
  type        = list(string)
  default     = ["10.0.5.0/24", "10.0.6.0/24"]
}

variable "vpc_azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  default     = ["ca-central-1a", "ca-central-1b"]
}

variable "vpc_enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  type        = bool
  default     = true
}

variable "vpc_single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  type        = bool
  default     = false
}

variable "vpc_private_subnet_tags" {
  description = "Additional tags for the private subnets"
  type        = map(string)
  default = {
    class = "Private-Subnet"
  }
}

variable "vpc_public_subnet_tags" {
  description = "Additional tags for the public subnets"
  type        = map(string)
  default = {
    class = "Public-Subnet"
  }
}

variable "vpc_database_subnet_tags" {
  description = "Additional tags for the database subnets"
  type        = map(string)
  default = {
    class = "Database-subnet"
  }
}

variable "vpc_create_database_subnet_route_table" {
  description = "Controls if separate route table for database should be created"
  type        = bool
  default     = true
}

variable "vpc_create_database_subnet_group" {
  description = "Controls if database subnet group should be created (n.b. database_subnets must also be set)"
  type        = bool
  default     = true
}

variable "vpc_enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "vpc_enable_dns_support" {
  description = "Should be true to enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "vpc_database_subnet_group_name" {
  description = "Name of database subnet group"
  type        = string
  default     = "rds-subnet-group"
}

variable "vpc_one_nat_gateway_per_az" {
  description = "Deploy one NAT gateway in each AZ"
  type        = bool
  default     = true
}