provider "aws" {
  region = "us-east-2"
}
provider "tls" {}
provider "local" {}
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}
data "aws_vpc" "default" {
  default = true
}
data "aws_security_group" "default" {
  vpc_id = data.aws_vpc.default.id
  filter {
    name = "tag:Name"
    values = ["default-vpc-default-security-group"]
  }
}
data "aws_subnets" "public_subnets" {
  filter {
    name = "vpc-id"
    values = [ data.aws_vpc.default.id ]
  }
  filter {
    name = "tag:Name"
    values = [ "default" ]
  }
}
resource "tls_private_key" "keypair" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}
resource "aws_key_pair" "key_pair" {
  key_name   = local.Name
  public_key = tls_private_key.keypair.public_key_openssh
}
resource "local_file" "aws_server_private_key" {
  filename = "${aws_key_pair.key_pair.key_name}.pem"
  content = tls_private_key.keypair.private_key_pem
}
resource "aws_security_group_rule" "ssh" {
  for_each = toset(["22"])
  from_port = each.value
  to_port = each.value
  type = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
  protocol = "TCP"
  description = "managed by terraform"
  security_group_id = data.aws_security_group.default.id
}
resource "aws_instance" "aws_instance" {
  count = var.count_number
  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name = aws_key_pair.key_pair.key_name
  root_block_device {
    delete_on_termination = true
    volume_type = "gp2"
    volume_size = var.volume_size
    tags = {
      Name = var.Name
    }
  }
  vpc_security_group_ids = [ data.aws_security_group.default.id ]
  subnet_id = data.aws_subnets.public_subnets.ids[0]
  tags = {
    Name = var.Name
  }
}
# resource "null_resource" "copy_pem_file" {
#   count = var.count_number
#   provisioner "file" {
#     connection {
#       type = "ssh"
#       user = "ubuntu"
#       host = aws_instance.aws_instance[count.index].public_ip
#       private_key = tls_private_key.keypair.private_key_pem
#     }
#     source = "${aws_key_pair.key_pair.key_name}.pem"
#     destination = "${aws_key_pair.key_pair.key_name}.pem"
#   }
# }
resource "null_resource" "install_jenkins" {
  count = var.count_number
  provisioner "remote-exec" {
    connection {
      type = "ssh"
      user = "ubuntu"
      host = aws_instance.aws_instance[count.index].public_ip
      private_key = tls_private_key.keypair.private_key_pem
    }
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y default-jdk maven ansible",
      "wget https://get.jenkins.io/war/2.346/jenkins.war"
    ]
  }
}
