resource "tls_private_key" "dev_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "generated_key" {
  key_name   = var.generated_key_name
  public_key = tls_private_key.dev_key.public_key_openssh
}

resource "local_file" "pem_file" {
  #   filename = pathexpand("~/.ssh/${local.ssh_key_name}.pem")
  filename             = "${var.generated_key_name}.pem"
  file_permission      = "600"
  directory_permission = "700"
  sensitive_content    = tls_private_key.dev_key.private_key_pem
}