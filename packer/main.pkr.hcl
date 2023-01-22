variable "region" {
    type = string
    default = "us-east-1"
}

variable "base_ami" {
    type = string
    default = "ami-08fdec01f5df9998f"
}

packer {
  required_plugins {
    amazon = {
      version = ">= 1.1.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "openvpn-image-{{timestamp}}"
  instance_type = "t2.micro"
  region        = var.region
  # ubuntu 18.05 version
  source_ami   = var.base_ami
  ssh_username = "ubuntu"
  tags = {
    "source_ami_name" : "{{.SourceAMIName}}"
  }
}

build {
  sources = ["source.amazon-ebs.ubuntu"]
  name    = "openvpn-image-build"

  provisioner "file" {
    source      = "./scripts/openvpn_setup.sh"
    destination = "/tmp/openvpn_setup.sh"
  }

  provisioner "shell" {
    script = "./scripts/main.sh"
  }

  provisioner "shell" {
    inline = ["ls -ltr /tmp/", "ls -ltr /opt"]
  }
}
