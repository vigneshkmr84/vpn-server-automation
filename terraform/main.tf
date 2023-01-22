provider "aws" {
  region = var.region
}

resource "aws_key_pair" "vpn_server_keypair" {
  key_name   = "vpn_server_keypair"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "tf_key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "vpn_server_key-${var.region}.pem"
}

resource "aws_security_group" "vm_security_group" {
  name        = "vm_security_group"
  description = "Security group for the vpn server"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow UDP for VPN"
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "vpn_server_security_group"
  }
}

resource "aws_instance" "ec2_image" {
  ami                    = var.base_ami
  instance_type          = var.instance_size
  key_name               = "vpn_server_keypair"
  vpc_security_group_ids = [aws_security_group.vm_security_group.id]

  provisioner "remote-exec" {
    inline = [
      "sudo bash /opt/openvpn_setup.sh",
    ]
  }

  provisioner "local-exec" {
    command = "chmod 400 vpn_server_key-${var.region}.pem && scp -i vpn_server_key-${var.region}.pem -o StrictHostKeyChecking=no ubuntu@${self.public_ip}:/home/ubuntu/client1.ovpn ./client1-${var.region}.ovpn"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    password    = ""
    host        = self.public_ip
    private_key = tls_private_key.rsa.private_key_pem
  }

  tags = {
    Name = "Terraform VPN Server EC2"
    Environment = "dev"
    Terraform = "true"
  }
}