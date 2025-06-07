resource "aws_instance" "ops_runner" {
  ami                    = var.aws_ami_id
  instance_type          = var.instance_family
  subnet_id              = var.private_subnet_ids[0]
  vpc_security_group_ids = [var.workload_sg_id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name
  key_name               = aws_key_pair.ec2_key.key_name

  root_block_device {
    volume_size           = var.disk_size
    volume_type           = "gp3"
    delete_on_termination = true
    encrypted             = true
    kms_key_id            = "alias/aws/ebs"
  }
  lifecycle {
    ignore_changes = [root_block_device[0].kms_key_id]
  }
  tags = {
    Name = "${var.product}-${var.env}-ops-runner"
  }
}
