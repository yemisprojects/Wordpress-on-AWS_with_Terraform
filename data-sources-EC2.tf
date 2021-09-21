data "aws_ami" "amzlinux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# data "aws_ec2_instance_type_offerings" "example3" {
#   filter {
#     name   = "instance-type"
#     values = [var.instance_type]
#   }
#   location_type = "availability-zone"
# }