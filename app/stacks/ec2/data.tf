### IAM ###

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "s3_write_access" {
  statement {
    actions = ["s3:Get*", "s3:List*", "s3:PutObject*"]

    resources = ["arn:aws:s3:::*"]
  }
}

data "aws_availability_zones" "available" {}


data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-gp2"]
  }
}
