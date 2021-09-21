#!/bin/bash
###########################PREPARE LAMP Server#################################
sudo yum update -y 
sudo yum install -y httpd httpd-tools mod_ssl
sudo systemctl enable httpd && sudo systemctl start httpd

sudo amazon-linux-extras enable php7.4 && sudo yum clean metadata 
sudo yum install -y php php-{pear,cgi,common,curl,mbstring,gd,mysqlnd,gettext,bcmath,json,xml,fpm,intl,zip,cli,pdo,fpm}

#shared filesystem for all app servers
#sudo mkdir -p /var/www/html
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 ${efs_mount}:/ /var/www/html
sudo systemctl restart httpd

if [ -f /var/www/html/wp-config.php ]; then
     exit 0
fi 

##############CONFIGURE DB FOR WORDPPRESS full permissions#######################
sudo yum install -y mysql
mysql --user=${db_user} --password=${db_pass} -h ${db_host}  ${db_name} -e "CREATE USER '${wordpress_username}' IDENTIFIED BY '${wordpress_password}';GRANT ALL PRIVILEGES ON ${db_name}.* TO ${wordpress_username};FLUSH PRIVILEGES;"

######################INSTALL WORDPRESS##########################
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
cd wordpress && cp wp-config-sample.php wp-config.php

sed -i 's/database_name_here/${db_name}/g' wp-config.php
sed -i 's/username_here/${db_user}/g' wp-config.php
sed -i 's/password_here/${db_pass}/g'  wp-config.php
sed -i 's/localhost/${db_host}/g'  wp-config.php
sed -i "20 a define( 'WP_HOME', '${wphome_url}' ); \n\ndefine( 'WP_SITEURL', '${wpsite_url}' ); \n\nif (strpos(\$_SERVER['HTTP_X_FORWARDED_PROTO'], 'https') !== false)\n       \$_SERVER['HTTPS']='on';\n\n" wp-config.php

cd .. && sudo cp -r wordpress/* /var/www/html/ 
sudo chown -R apache:apache /var/www
sudo chmod 2775 /var/www && sudo find /var/www -type d -exec sudo chmod 2775 {} \;
sudo find /var/www -type f -exec sudo chmod 0664 {} \;
sudo systemctl restart httpd