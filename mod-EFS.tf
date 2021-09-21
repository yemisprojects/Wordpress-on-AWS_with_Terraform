resource "aws_efs_file_system" "efs" {
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  tags = {
    Name = "Wordpress-fileSystem"
  }
}

resource "aws_efs_mount_target" "mount_target-0" {

  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = module.vpc.private_subnets[0]
  security_groups = [module.efs_sg.security_group_id]
}

resource "aws_efs_mount_target" "mount_target-1" {

  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = module.vpc.private_subnets[1]
  security_groups = [module.efs_sg.security_group_id]
}