variable "dbusername" {

  description = "database username"
  type        = string
  default     = "dbusername"
}

variable "dbpassword" {

  description = "database password"
  type        = string
  default     = "dbpassword"
}
variable "dbidentifier" {
  description = "database identifier"
  type        = string
  default     = "db-instance-1"
}

variable "dbname" {
  description = "database name"
  type        = string
  default     = "wordpressdb"
}

variable "db_ismulti_az" {
  description = "True if it is to be deployed in multiple availabilty zones"
  type        = bool
  default     = true
}
variable "dbinstance_class" {
  description = "instance class for RDS instance"
  type        = string
  default     = "db.m5.large"
}