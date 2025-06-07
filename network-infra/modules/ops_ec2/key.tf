# Generate the RSA key pair
resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Register the public key with AWS
resource "aws_key_pair" "ec2_key" {
  key_name   = "${var.product}-${var.env}-ec2"
  public_key = tls_private_key.ec2_key.public_key_openssh
}

# Save the private key locally in .pem format
resource "local_file" "pem_file" {
  content              = tls_private_key.ec2_key.private_key_pem
  filename             = "${path.root}/keys/${var.product}-${var.env}-ec2.pem"
  file_permission      = "0600"
  directory_permission = "0700"
}
