output "public_ip" {
  value = aws_instance.aws_instance.*.public_ip
}
output "ami" {
  value = data.aws_ami.ubuntu.id
}
output "vpc_id" {
  value = data.aws_vpc.default.id
}
output "security_group_id" {
  value = data.aws_security_group.default.id
}
output "subnet_id" {
  value = data.aws_subnets.public_subnets.ids[0]
}
