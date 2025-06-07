# Create the IAM role for EC2 Instance Profile
resource "aws_iam_role" "ec2_instance_role" {
  name = "${var.product}-${var.env}-ec2-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      }
    ]
  })

  tags = {
    Name = "EC2InstanceRole"
  }
}

# Attach AmazonSSMManagedInstanceCore policy (needed for EC2 instance to use SSM)
resource "aws_iam_role_policy_attachment" "ssm_policy_attachment" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Custom policy to allow read/write access to S3 and DynamoDB
resource "aws_iam_policy" "s3_dynamo_policy" {
  name        = "${var.product}-${var.env}-ec2-policy"
  description = "Policy for read/write access to S3 and DynamoDB"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # Read/Write access to S3
      {
        Action = ["s3:ListBucket", "s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::*",
          "arn:aws:s3:::*/*"
        ]
      },
      # Read/Write access to DynamoDB
      {
        Action   = ["dynamodb:BatchGetItem", "dynamodb:GetItem", "dynamodb:PutItem", "dynamodb:UpdateItem", "dynamodb:DeleteItem"]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# Attach the custom S3 and DynamoDB policy to the EC2 role
resource "aws_iam_role_policy_attachment" "s3_dynamo_policy_attachment" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = aws_iam_policy.s3_dynamo_policy.arn
}

# Create the EC2 instance profile (to associate with the EC2 instance)
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${var.product}-${var.env}-ec2-instance-profile"
  role = aws_iam_role.ec2_instance_role.name
}
