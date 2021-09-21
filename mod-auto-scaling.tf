module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "4.6.0"

  name                = "Wordpress instance_asg"
  min_size            = 1
  max_size            = 2
  desired_capacity    = 1
  health_check_type   = "ELB"
  vpc_zone_identifier = module.vpc.private_subnets
  #========================================================================================
  # LINK TO APPLICATION LOAD BALANCER
  #========================================================================================
  target_group_arns = module.alb.target_group_arns

  #========================================================================================
  # LAUNCH_TEMPLATE
  #========================================================================================
  use_lt                 = true
  create_lt              = true
  lt_name                = "launch_template_for_web_servers"
  description            = "To be used by Web servers in private subnet"
  update_default_version = true
  security_groups        = [module.private_webserver_sg.security_group_id]
  image_id               = data.aws_ami.amzlinux.id
  instance_type          = var.instance_type
  user_data_base64       = base64encode(data.template_file.user_data_launchtemplate.rendered)
  ebs_optimized          = true
  enable_monitoring      = true
  key_name               = aws_key_pair.generated_key.key_name

  block_device_mappings = [
    {
      # Root volume
      device_name = "/dev/xvda"
      no_device   = 0
      ebs = {
        delete_on_termination = true
        encrypted             = false
        volume_size           = 20
        volume_type           = "gp2"
      }
    }
  ]

}



# ========================================================================================
# OLD bootstrap script for autoscaled instances using locals instead of template file
# ========================================================================================
# locals {
#   user_data = <<-EOT
# #!/bin/bash
# ###########################PREPARE LAMP Server#################################
# sudo yum update -y 
# sudo yum install -y httpd httpd-tools mod_ssl
# sudo systemctl enable httpd && sudo systemctl start httpd

# sudo amazon-linux-extras enable php7.4 && sudo yum clean metadata 
# sudo yum install -y php php-{pear,cgi,common,curl,mbstring,gd,mysqlnd,gettext,bcmath,json,xml,fpm,intl,zip,cli,pdo,fpm}

# sudo yum install -y mysql

# #shared filesystem for all app servers
# #sudo mkdir -p /var/www/html
# sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 ${aws_efs_file_system.efs.dns_name}:/ /var/www/html
# sudo systemctl restart httpd

# if [ -f /var/www/html/wp-config.php ]; then
#      exit 0
# fi 

# ##############CONFIGURE DB FOR WORDPPRESS full permissions#######################

# mysql --user=dbusername --password=dbpassword -h ${module.rds.db_instance_address}  wordpressdb -e "CREATE USER 'wordpressuser' IDENTIFIED BY 'wordpresspassword';GRANT ALL PRIVILEGES ON wordpressdb.* TO wordpressuser;FLUSH PRIVILEGES;"

# ######################INSTALL WORDPRESS##########################
# wget https://wordpress.org/latest.tar.gz
# tar -xzf latest.tar.gz
# cd wordpress && cp wp-config-sample.php wp-config.php

# sed -i 's/database_name_here/wordpressdb/g' wp-config.php
# sed -i 's/username_here/dbusername/g' wp-config.php
# sed -i 's/password_here/dbpassword/g'  wp-config.php
# sed -i 's/localhost/${module.rds.db_instance_address}/g'  wp-config.php
# sed -i "20 a define( 'WP_HOME', 'https://www.${data.aws_route53_zone.route53_domain.name}' ); \n\ndefine( 'WP_SITEURL', 'https://www.${data.aws_route53_zone.route53_domain.name}' ); \n\nif (strpos(\$_SERVER['HTTP_X_FORWARDED_PROTO'], 'https') !== false)\n       \$_SERVER['HTTPS']='on';\n\n" wp-config.php

# cd .. && sudo cp -r wordpress/* /var/www/html/ 
# sudo chown -R apache:apache /var/www
# sudo chmod 2775 /var/www && sudo find /var/www -type d -exec sudo chmod 2775 {} \;
# sudo find /var/www -type f -exec sudo chmod 0664 {} \;
# sudo systemctl restart httpd

# EOT
# }