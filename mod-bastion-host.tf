resource "aws_instance" "bastion_host" {
  ami                    = data.aws_ami.amzlinux.id
  instance_type          = var.bastion_instance_type
  subnet_id              = module.vpc.public_subnets[1]
  key_name               = aws_key_pair.generated_key.key_name
  vpc_security_group_ids = [module.bastion_sg.security_group_id]
  # user_data              = <<EOF
  #               #! /bin/bash
  #               sudo yum update -y
  #               sudo yum install -y httpd
  #               sudo systemctl enable httpd
  #               sudo service httpd start  
  #               echo "<h1>Welcome to my Terraform project</h1>" | sudo tee /var/www/html/index.html
  # EOF
  tags = {
    Name = "Bastion"
  }
}

#========================================================================================
# TEST node for private subnet
#========================================================================================
# resource "aws_instance" "ec2_in_private_subnet" { //Using as bastion and web server
#   ami                    = data.aws_ami.amzlinux.id
#   instance_type          = var.instance_type
#   subnet_id              = module.vpc.private_subnets[0]
#   key_name               = aws_key_pair.generated_key.key_name
#   vpc_security_group_ids = [module.private_webserver_sg.security_group_id]
#   user_data              = <<EOF
#                 #! /bin/bash
#                 sudo yum update -y
#                 sudo yum install -y httpd
#                 sudo systemctl enable httpd
#                 sudo service httpd start  
#                 echo "<h1>Welcome to my First terraform project</h1>" | sudo tee /var/www/html/index.html
#   EOF
#   tags = {
#     Name = "WebServer"
#   }
# }
