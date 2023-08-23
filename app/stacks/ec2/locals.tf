locals {
  name     = "test"
  region   = "ap-south-1"
  profile  = "teko-security-luu-tekos-dev"
  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  user_data = <<-EOT
    #!/bin/bash
    echo "Hello Terraform!"
  EOT

  tags = {
    Name = local.name
    Env  = "test"

  }
}
