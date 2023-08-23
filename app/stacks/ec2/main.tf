resource "aws_iam_role" "ec2_iam_role" {
  name = "ec2_iam_role"

  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

resource "aws_iam_role_policy" "join_policy" {
  depends_on = ["aws_iam_role.ec2_iam_role"]
  name       = "join_policy"
  role       = aws_iam_role.ec2_iam_role.name

  policy = data.aws_iam_policy_document.s3_write_access.json
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "instance_profile"
  role = aws_iam_role.ec2_iam_role.name
}

### Instance ###
module "ec2_instance" {
  source = "../../modules/ec2-instance"

  name = local.name

  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t2.micro"
  availability_zone           = element(module.vpc.azs, 0)
  subnet_id                   = element(module.vpc.public_subnets, 0)
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.instance_profile.name
  vpc_security_group_ids      = [aws_security_group.ssh.id]
  key_name                    = "terraform_ec2_key"
  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      throughput  = 200
      volume_size = 50
    }
  ]

  tags = local.tags
}

resource "aws_security_group" "ssh" {
  name        = "ssh"
  description = "Allow SSH traffic from everywhere"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "ssh_ingress" {
  security_group_id = aws_security_group.ssh.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ssh_egress" {
  security_group_id = aws_security_group.ssh.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_key_pair" "terraform_ec2_key" {
  key_name   = "terraform_ec2_key"
  public_key = file("~/.ssh/terraform_ec2_key.pub")
}


