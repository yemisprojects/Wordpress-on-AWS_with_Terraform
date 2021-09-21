# Wordpress deployed using Terraform on AWS

version 1.0

Overview
------------
This project deploys and hosts Wordpress on AWS using Terraform. WordPress is an open-source blogging tool and content management system (CMS) based on PHP and MySQL. The architecture adopted can be used for production workloads while requiring minimal management responsibilities. This repository consists of a set of terraform configuration files which automatically handles the provisioning and management of the underlying infratucture. The architecture is secure, highly available with each tier being able to scale independently.

AWS Architecture
---------------------
Insert Image here

Services used and Cost
-----------------------
AWS pricing is based on your usage of each individual service. The total combined usage of each service will create your monthly bill.
AWS Services deployed includes: Amazon Virtual Private Cloud (Amazon VPC), Amazon Elastic Compute Cloud (Amazon EC2), Auto Scaling, Elastic Load Balancing (Application Load Balancer),Amazon Relational Database Service (Amazon RDS), Amazon Elastic File System (Amazon EFS), Amazon Route53 and Amazon Certificate Manager (Amazon ACM) 

Total Billing Estimates
-------------------------
The total cost of building a WordPress website will vary depending on your usage and the instance types you select for the web server and database instance. Using the default configuration in this repo, it could cost $..../month to host the WordPress site based on the cost optimization feature of Terraform cloud. This cost reflects the minimum resources recommended for a production WordPress workload, with only one active web server and a separate Amazon RDS MySQL database instance. The total cost may increase if you use Auto Scaling to increase the number of web server instances in the event of increased traffic to your WordPress site (approximately $../month for each additional web server assuming that the web server is active for the entire month)

To see a detailed breakdown of costs and adjust your billing estimate, explore the AWS Pricing Calculator https://calculator.aws/#/

Pre-requistes before starting
------------------------------
An AWS Account to provision resources to host wordpress : sign up link https://portal.aws.amazon.com/gp/aws/developer/registration/index.html
Install AWS CLI https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html
Configure AWS CLI using AWS configure to setup a default profile  https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html
Install Terraform version ..(number)... : https://www.terraform.io/downloads.html
 Use Route53 as the DNS service for your domain and create a public hosted zone for the domain in Route53
 - If you dont have a domain, you can Register one using Route53 afterwhich a hosted zone is created by default by Route53
  https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/domain-register.html#domain-register-procedure
 - If your domain is registered with an external DNS service, migrate the domain registeration and or service to Route53 https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/migrate-dns-domain-inactive.html

Steps to Run to deploy the infrastructure and website
--------------------------------------------------------
git clone
change to Wordpress-on-AWS_with_Terraform
cd Wordpress-on-AWS_with_Terraform
Required
Update the route53_public_zone_name variable value to your domain name in the input-parameters.auto.tfvars to your domain name used in Route53 as mentioned in the pre-requisites section
Initialize configuration and deploy infrasture and website
    terraform init
    terraform plan
    terraform apply -auto-approve
Destroy infrasture
    terraform destroy -auto-approve


List of AWS Resources Created:
---------------------------------
Amazon Virtual Private Cloud (Amazon VPC)
Internet Gateway (IGW)
NAT Gateway (on each public subnet)
Amazon VPC subnets (public, private (data, web)) in all the Availability Zones (AZs) selected
Routing tables for public subnets - routing through IGW
Routing tables for private subnets - routing through NAT Gateway
Mulitple VPC Security Groups
Bastion host in a public subent - in public subnets (public)
Amazon Relational Database Service (Amazon RDS) with MuSQl engine - in private subnets (data)
Amazon Elastic File System (Amazon EFS) file system - with mount targets in private subnets (data) 
Amazon Elastic Load Balancing (Amazon ELB) Application Load Balancer (ALB) - in public subnets (public)
Web Auto Scaling Group (launching 1 instances) - in private subnets (web)
Amazon Route53 DNS record set
Amazon Certifcate Manager for certificates used with Amazon ELB
EC2 instances to host wordpress site and key pair to access them through a Bastion host 

Input Parameters which can control cost (you can update them within the input paramters tf.vars)
-------------------------------------------------------------------------------------------------


Output
---------
website url
bastion_host_public_ip
sh keypair filename to access servers

Name+++++++++++Version
terrafrom	~> 1.0
aws	~> 3.58


Project version 2.0 (under works)
------------------------------------------
To include cloudfront distribution to serve static and dynamic content from S3 and EC2