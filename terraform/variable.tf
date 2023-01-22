variable "instance_size" {
  type        = string
  description = "ec2 web server size"
  default     = "t2.micro"
}

variable "vpc_id" {
  type    = string
  default = "vpc-0bcb03154fdc3d366"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "base_ami" {
  type    = string
  default = "ami-0cea65de5e55490cc"
}

variable "key_name" {
    type = string
    default = "vpn_server_key"
}