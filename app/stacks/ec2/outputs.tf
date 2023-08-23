# This is where you put your outputs declaration
output "ec2_global_ips" {
  value = module.ec2_instance.public_ip
}
