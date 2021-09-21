variable "wordpress_username" {
  description = "username for wordpress user in RDS"
  type        = string
  default     = "wordpressuser"
}

variable "wordpress_password" {
  description = "password for wordpress user in RDS"
  type        = string
  default     = "wordpresspassword"
}

data "template_file" "user_data_launchtemplate" {
  template = file("userdata.sh")

  vars = {
    db_host            = module.rds.db_instance_address
    db_user            = var.dbusername
    db_pass            = var.dbpassword
    db_name            = var.dbname
    efs_mount          = aws_efs_file_system.efs.dns_name
    wordpress_username = var.wordpress_username
    wordpress_password = var.wordpress_password
    wphome_url         = "https://${aws_route53_record.www.name}"
    wpsite_url         = "https://${aws_route53_record.www.name}"
  }
}



# data "template_file" "user_data_launchtemplate" {
#   template = <<EOF
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
# sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 ${efs_mount}:/ /var/www/html
# sudo systemctl restart httpd

# if [ -f /var/www/html/wp-config.php ]; then
#      exit 0
# fi 

# ##############CONFIGURE DB FOR WORDPPRESS full permissions#######################

# mysql --user=${db_user} --password=${db_pass} -h ${db_host}  ${db_name} -e "CREATE USER '${wordpress_username}' IDENTIFIED BY '${wordpress_password}';GRANT ALL PRIVILEGES ON ${db_name}.* TO ${wordpress_username};FLUSH PRIVILEGES;"

# ######################INSTALL WORDPRESS##########################
# wget https://wordpress.org/latest.tar.gz
# tar -xzf latest.tar.gz
# cd wordpress && cp wp-config-sample.php wp-config.php

# sed -i 's/database_name_here/${db_name}/g' wp-config.php
# sed -i 's/username_here/${db_user}/g' wp-config.php
# sed -i 's/password_here/${db_pass}/g'  wp-config.php
# sed -i 's/localhost/${db_host}/g'  wp-config.php
# sed -i "20 a define( 'WP_HOME', '$wphome_url' ); \n\ndefine( 'WP_SITEURL', '$wpsite_url' ); \n\nif (strpos(\$_SERVER['HTTP_X_FORWARDED_PROTO'], 'https') !== false)\n       \$_SERVER['HTTPS']='on';\n\n" wp-config.php

# cd .. && sudo cp -r wordpress/* /var/www/html/ 
# sudo chown -R apache:apache /var/www
# sudo chmod 2775 /var/www && sudo find /var/www -type d -exec sudo chmod 2775 {} \;
# sudo find /var/www -type f -exec sudo chmod 0664 {} \;
# sudo systemctl restart httpd

# EOF
# }

# data "template_file" "user_data_launchtemplate" {
#   template = <<EOF
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

# EOF
# }